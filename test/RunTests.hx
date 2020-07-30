package;

import datetime.DateTime;
import bp.duck.proxy.WildDuckProxy;
import bp.duck.proxy.models.Requests;
import bp.duck.proxy.models.Results;
import tink.http.containers.*;
import tink.http.Response;
import tink.web.routing.*;
import tink.http.clients.*;
import tink.web.proxy.Remote;
import tink.url.Host;
import tink.testrunner.Reporter;
import tink.testrunner.*;
import tink.unit.*;

using tink.io.Source;
using bp.test.Utils;

import bp.grpc.GrpcStreamParser;
import bp.grpc.GrpcStreamWriter;
import tink.streams.*;
import tink.streams.Stream;

using tink.CoreApi;
using Lambda;
using bp.test.Utils;
using RunTests;

class TestTools {
	public static inline function reportErrors(promise:Promise<AssertionBuffer>, asserts:AssertionBuffer)
		return promise.tryRecover(e -> {
			asserts.assert(false, '$e');
			asserts.done();
		}).eager();

	public static inline function verify(result:BasicResult, asserts:AssertionBuffer)
		asserts.assert(result.success, "Should have a successful response");
}

class RunTests {
	static function main() {
		ANSI.stripIfUnavailable = false;
		var reporter = new BasicReporter(new AnsiFormatter());
		Runner.run(TestBatch.make([
			new UserTests(),
			new AddressTests(),
			new MailboxTestsPart1(),
			// new MailboxTestsPart2(),
			new StorageTests(),
			new ASPTests()
		]), reporter).handle(Runner.exit);
	}
}

class ProxyTestBase {
	public function new() {}

	var userId(get, never):String;

	inline function get_userId()
		return State.userId;

	var user(get, never):tink.web.proxy.Remote<UserProxy>;

	inline function get_user()
		return this.wildDuckProxy.users().get(userId);

	var wildDuckProxy:bp.duck.Proxy;
	var client:NodeClient;

	@:setup
	public function setup() {
		client = new NodeClient();
		wildDuckProxy = new bp.duck.Proxy(client, new RemoteEndpoint(new Host('localhost', 8080)));
		return Noise;
	}
}

class State {
	public static var userId:String;
	public static var random = Std.random(100000);
	public static var deleteMe:String;
	public static var createdDate:String;
}

@:asserts
class UserTests extends ProxyTestBase {
	@:describe("Should create a user")
	public function create_user() {
		var random = State.random;
		var request = {
			username: 'test$random',
			password: "someSecret",
			address: 'test$random@brave-pi.io',
		};
		wildDuckProxy.users().create(request).next(res -> {
			res.verify(asserts);
			State.userId = res.id;
			State.createdDate = DateTime.now().snap(Second(Down)).toString();
			asserts.done();
		}).reportErrors(asserts).eager();

		return asserts;
	}

	@:describe("Should be able to access auth log")
	public function authlog() {
		wildDuckProxy.users()
			.get(userId)
			.authlog()
			.list({
				action: "account created"
			})
			.next(res -> {
				res.verify(asserts);
				var dateTime:DateTime = res.results[0].created;
				dateTime.snap(Second(Down));
				asserts.assert('$dateTime' == State.createdDate);
				asserts.done();
			})
			.reportErrors(asserts)
			.eager();
		return asserts;
	}

	@:describe("Should be able to resolve a user by username")
	public function resolve_user() {
		wildDuckProxy.users()
			.resolve('test${State.random}')
			.next(res -> {
				res.verify(asserts);
				asserts.assert(res.id == userId);
				asserts.done();
			})
			.reportErrors(asserts)
			.eager();

		return asserts;
	}

	@:describe("Should be able to select users with a query")
	public function select_users() {
		var random = State.random;
		var promises = [
			for (i in 1...11)
				wildDuckProxy.users().create({
					username: 'test${random + i}',
					password: "someSecret",
					address: 'test${random + i}@brave-pi.io',
				})
		];
		Promise.inParallel(promises).next(res -> {
			asserts.assert(res.length == 10, "Should have created 10 users");
			State.deleteMe = res[res.length - 1].id;
			wildDuckProxy.users().select({
				query: 'test',
				limit: 10
			}).next(res -> {
				res.verify(asserts);
				asserts.assert(res.results.length == 10, 'Found at least 10 users matching query (${res.total})');
				asserts.done();
			}).reportErrors(asserts).eager();
		}).eager();
		return asserts;
	}

	@:describe("Should be able to get user info")
	public function user_info() {
		wildDuckProxy.users().get(userId).info().next(res -> {
			res.verify(asserts);
			asserts.assert(res.username == 'test${State.random}', 'Should match username of user we created');
			asserts.done();
		}).reportErrors(asserts).eager();
		return asserts;
	}

	@:describe('Should be able to delete a user')
	public function delete_user() {
		wildDuckProxy.users().get(State.deleteMe).delete({
			sess: 'tink_unittest',
			ip: '127.0.0.1'
		}).next(res -> {
			res.verify(asserts);
			asserts.done();
		}).reportErrors(asserts).eager();
		return asserts;
	}

	@:describe("Should be able to reset a user's quota")
	public function user_reset_quota() {
		wildDuckProxy.users().get(userId).resetQuota().next(res -> {
			res.verify(asserts);
			asserts.assert(res.storageUsed == 0, "New user should have a quota of 0");
			asserts.done();
		}).reportErrors(asserts).eager();
		return asserts;
	}

	var newPass:String;

	@:describe("Should be able to get a new, auto-generated password")
	public function reset_pass() {
		wildDuckProxy.users().get(userId).resetPass({
			sess: "tink_unittest session",
			ip: "127.0.0.1"
		}).next(res -> {
			res.verify(asserts);

			asserts.assert((newPass = res.password) != null);

			asserts.done();
		}).reportErrors(asserts).eager();
		return asserts;
	}

	@:describe("Should be able to update the password")
	public function update_pass() {
		wildDuckProxy.users().get(userId).update({
			// existingPassword: newPass,
			password: 'foobarbazquxquux'
		}).next(res -> {
			// TODO: investigate password verification failure
			res.verify(asserts);
			if (res.error != null)
				trace(res.error);
			asserts.done();
		}).reportErrors(asserts).eager();
		return asserts;
	}

	@:describe("Should fail with an invalid access token")
	public function access_token_fail() {
		wildDuckProxy.users('some-made-up-token').get(userId).info().next(_ -> {
			asserts.assert('should have failed' == null);
			asserts.done();
		}).tryRecover(e -> {
			asserts.assert(e.code == Forbidden, "Should get a 403 FORBIDDEN response");
			asserts.done();
		});
		return asserts;
	}
}

@:asserts
class AddressTests extends ProxyTestBase {
	var addressId:String;
	var addresses(get, never):tink.web.proxy.Remote<UserAddressesProxy>;

	inline function get_addresses()
		return user.addresses();

	@:describe("Should be able to create an address and get an ID")
	public function create_address() {
		addresses.create({
			address: 'some-made-up-address-i-guess-${State.random}@brave-pi.io',
			name: 'tink_address',
		}).next(res -> {
			res.verify(asserts);
			asserts.assert(res.id != null);
			addressId = res.id;
			asserts.done();
		}).reportErrors(asserts).eager();
		return asserts;
	}

	@:describe("Should be able to list the addresses for the user")
	public function address_list() {
		addresses.list().next(res -> {
			res.verify(asserts);
			asserts.assert(res.results.length == 2, "there should be 2 addresses, because one was added after the user was created.");
			asserts.done();
		}).reportErrors(asserts).eager();
		return asserts;
	}

	function checkAddressName(asserts:AssertionBuffer, ?name:String = "tink_address")
		return addresses.get(addressId).info().next(res -> {
			res.verify(asserts);
			asserts.assert(res.name == name, 'Name for Address #$addressId matches the name we set');
			asserts.done();
		}).reportErrors(asserts).eager();

	@:describe("Should be able to get the info for an address")
	public function address_info() {
		checkAddressName(asserts);
		return asserts;
	}

	@:describe("Should be able to update the address")
	public function update_address() {
		addresses.get(addressId).update({
			name: "bp_address"
		}).next(res -> {
			res.verify(asserts);
			asserts.done();
		}).reportErrors(asserts).eager();
		return asserts;
	}

	@:describe("Should match the updated name")
	public function verify_update() {
		checkAddressName(asserts, 'bp_address');
		return asserts;
	}

	@:describe("Should be able to delete the address")
	public function delete_address() {
		addresses.get(addressId).delete().next(res -> {
			res.verify(asserts);
			asserts.done();
		}).reportErrors(asserts).eager();
		return asserts;
	}
}

@:asserts
class MailboxTestsPart1 extends ProxyTestBase {
	var mailboxes(get, never):tink.web.proxy.Remote<UserMailboxProxy>;
	var mailboxId:String;

	inline function get_mailboxes()
		return user.mailboxes();

	@:describe("Should be able to create a mailbox")
	public function create_mailbox() {
		mailboxes.create({
			path: 'Some New Mailbox'
		}).next(res -> {
			res.verify(asserts);
			asserts.assert((mailboxId = res.id) != null, "should have gotten a mailbox ID back");
			asserts.done();
		}).reportErrors(asserts).eager();
		return asserts;
	}

	@:describe("Should be able to get a list of mailboxes")
	public function mailbox_select() {
		mailboxes.select({
			counters: true,
			sizes: true,
			showHidden: true
		}).next(res -> {
			res.verify(asserts);
			asserts.assert(res.results.length == 6, "There should be 6; 5 default mailboxes in addition to the one we created");
			var boxNames = ['INBOX', 'Drafts', 'Junk', 'Sent Mail', 'Some New Mailbox', 'Trash'];
			res.results.iter(mailbox -> {
				var foundBox = boxNames.find(boxName -> boxName == mailbox.name);
				if (foundBox != null)
					asserts.assert(mailbox.name == foundBox, 'Found expected mailbox for ${mailbox.name}');
				else
					asserts.assert(false, 'Could not find box ${mailbox.name}');
			});
			asserts.done();
		}).reportErrors(asserts).eager();
		return asserts;
	}

	@:describe("Should be able to update a mailbox")
	public function mailbox_update() {
		mailboxes.get(this.mailboxId).update({
			path: 'New Path'
		}).next(res -> {
			res.verify(asserts);
			asserts.done();
		}).reportErrors(asserts).eager();
		return asserts;
	}

	@:describe("Should be able to get the info about a mailbox")
	public function mailbox_info() {
		mailboxes.get(this.mailboxId).info().next(res -> {
			res.verify(asserts);
			asserts.assert(res.path == "New Path", "Should match the updated mailbox path");
			asserts.done();
		}).reportErrors(asserts).eager();
		return asserts;
	}

	@:describe("Should be able to delete a mailbox")
	public function delete_mailbox() {
		mailboxes.get(this.mailboxId).delete().next(res -> {
			res.verify(asserts);
			asserts.done();
		}).reportErrors(asserts).eager();
		return asserts;
	}
}

@:asserts
class StorageTests extends ProxyTestBase {
	var storage(get, never):tink.web.proxy.Remote<StorageProxy>;
	var fileId:String;

	inline function get_storage()
		return user.storage();

	public function upload_file() {
		var fileStream:IdealSource = asys.io.File.readStream('./fixtures/pic.png').idealize(e -> '$e');
		storage.create(fileStream, {
			filename: 'state-stamp.png',
			contentType: 'image/png'
		}, 'application/binary').next(res -> {
			res.verify(asserts);
			this.fileId = res.id;
			asserts.done();
		}).reportErrors(asserts).eager();

		return asserts;
	}

	public function download_file() {
		storage.get(fileId).download().next(res -> {
			Promise.inParallel([
				res.body.all(),
				asys.io.File.getBytes('./fixtures/pic.png').next(tink.Chunk.ofBytes)
			]).next(results -> {
				asserts.assert(results[0].toBytes().compare(results[1].toBytes()) == 0, "Image content should be the same");
				asserts.done();
			}).eager();

		}).reportErrors(asserts);
		return asserts;
	}
}

@:asserts
class ASPTests extends ProxyTestBase {
	var asps(get, never):tink.web.proxy.Remote<ASPsProxy>;

	inline function get_asps()
		return user.asps();

	var auth(get, never):tink.web.proxy.Remote<AuthProxy>;

	inline function get_auth()
		return wildDuckProxy.auth();

	var aspId:String;
	var password:String;
	var loginTime:String;

	public function create_asp() {
		asps.create({
			description: "test",
			scopes: ["imap", "smtp"],
			generateMobileconfig: true,
			address: 'test${State.random}@brave-pi.io',
			sess: "tink_unittest",
			ip: "127.0.0.1"
		}).next(res -> {
			this.aspId = res.id;
			this.password = res.password;
			res.verify(asserts);
			asserts.done();
		}).reportErrors(asserts).eager();
		return asserts;
	}

	function audit() {
		var loginTime = DateTime.now();
		this.loginTime = loginTime.snap(Second(Down)).toString();
	}

	public function asp_auth() {
		auth.login({
			username: 'test${State.random}',
			password: this.password,
			scope: "smtp"
		}).next(res -> {
			res.verify(asserts);
			audit();
			asserts.done();
		}).reportErrors(asserts).eager();
		return asserts;
	}

	public function asp_invalid_scope() {
		auth.login({
			username: 'test${State.random}',
			password: this.password,
			scope: "master"
		}).next(res -> {
			asserts.assert(!res.success);
			audit();
			asserts.done();
		}).tryRecover(e -> {
			asserts.assert(e.code == Forbidden, '$e');
			// audit();
			asserts.done();
		}).eager();
		return asserts;
	}

	public function list_asps() {
		asps.list({
			showAll: true
		}).next(res -> {
			asserts.assert(res.results.exists(asp -> asp.id == this.aspId), "Should be able to find existing ASP");
			res.verify(asserts);
			asserts.done();
		}).reportErrors(asserts).eager();
		return asserts;
	}

	public function asp_info() {
		asps.get(this.aspId).info().next(res -> {
			if (res.lastUse.time != false) {
				var lastUse:DateTime = (res.lastUse.time : String);
				lastUse.snap(Second(Down));
				asserts.assert(lastUse == this.loginTime, 'Last use should match the time we audited for our last login [$lastUse] x [$loginTime]');
			}
			res.verify(asserts);
			asserts.done();
		}).reportErrors(asserts).eager();
		return asserts;
	}
}
