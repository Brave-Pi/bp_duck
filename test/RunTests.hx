package;

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

class RunTests {
	static function main() {
		ANSI.stripIfUnavailable = false;
		var reporter = new BasicReporter(new AnsiFormatter());
		Runner.run(TestBatch.make([new UserTests(), new AddressTests(), new MailboxTests()]), reporter).handle(Runner.exit);
	}
}

class ProxyTestBase {
	public function new() {}

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
}

@:asserts
class UserTests extends ProxyTestBase {
	public function create_user() {
		var random = State.random;
		var request = {
			username: 'test$random',
			password: "someSecret",
			address: 'test$random@brave-pi.io',
		};
		wildDuckProxy.users().create(request).next(res -> {
			asserts.assert(res.success);
			State.userId = res.id;

			asserts.done();
		}).tryRecover(e -> {
			trace(e);
			asserts.assert(false, '$e');
			asserts.done();
		}).eager();

		return asserts;
	}

	public function user_reset_quota() {
		wildDuckProxy.users().get(State.userId).resetQuota().next(res -> {
			asserts.assert(res.success);
			asserts.assert(res.storageUsed == 0);
			asserts.done();
		}).tryRecover(e -> {
			trace(e);
			asserts.assert(false, '$e');
			asserts.done();
		}).eager();
		return asserts;
	}

	public function user_info() {
		wildDuckProxy.users().get(State.userId).info().next(res -> {
			asserts.assert(res.success);
			asserts.done();
		}).tryRecover(e -> {
			trace(e);
			asserts.assert(false, '$e');
			asserts.done();
		}).eager();
		return asserts;
	}

	var newPass:String;

	public function reset_pass() {
		wildDuckProxy.users().get(State.userId).resetPass({
			sess: "tink_unittest session",
			ip: "127.0.0.1"
		}).next(res -> {
			asserts.assert(res.success);

			trace(newPass = res.password);

			asserts.done();
		}).tryRecover(e -> {
			trace(e);
			asserts.assert(false, '$e');
			asserts.done();
		}).eager();
		return asserts;
	}

	public function update_pass() {
		wildDuckProxy.users().get(State.userId).update({
			// existingPassword: newPass,
			password: 'foobarbazquxquux'
		}).next(res -> {
			// TODO: investigate password verification failure
			asserts.assert(res.success);
			if (res.error != null)
				trace(res.error);
			asserts.done();
		}).tryRecover(e -> {
			trace(e);
			asserts.assert(false, '$e');
			asserts.done();
		}).eager();
		return asserts;
	}

	public function access_token_fail() {
		wildDuckProxy.users('some-made-up-token').get(State.userId).info().next(_ -> {
			asserts.assert('should have failed' == null);
			asserts.done();
		}).tryRecover(e -> {
			asserts.assert(e.code == Forbidden);
			asserts.done();
		});
		return asserts;
	}
}

@:asserts
class AddressTests extends ProxyTestBase {
	var addressId:String;
	var addresses(get, never):tink.web.proxy.Remote<UserAddressProxy>;

	inline function get_addresses()
		return this.wildDuckProxy.users().get(State.userId).addresses();

	public function create_address() {
		addresses.create({
			address: 'some-made-up-address-i-guess-${State.random}@brave-pi.io',
			name: 'tink_address',
		}).next(res -> {
			asserts.assert(res.success);
			addressId = res.id;
			asserts.done();
		}).tryRecover(e -> {
			trace(e);
			asserts.assert(false, '$e');
			asserts.done();
		}).eager();
		return asserts;
	}

	public function address_list() {
		addresses.list().next(res -> {
			asserts.assert(res.success);
			asserts.assert(res.results.length == 2);
			asserts.done();
		}).tryRecover(e -> {
			trace(e);
			asserts.assert(false, '$e');
			asserts.done();
		}).eager();
		return asserts;
	}

	function checkAddressName(asserts:AssertionBuffer, ?name:String = "tink_address")
		return addresses.get(addressId).next(res -> {
			asserts.assert(res.success);
			asserts.assert(res.name == name);
			asserts.done();
		}).tryRecover(e -> {
			trace(e);
			asserts.assert(false, '$e');
			asserts.done();
		}).eager();

	public function address_info() {
		checkAddressName(asserts);
		return asserts;
	}

	public function update_address() {
		addresses.update(addressId, {
			name: "bp_address"
		}).next(res -> {
			asserts.assert(res.success);
			asserts.done();
		}).tryRecover(e -> {
			trace(e);
			asserts.assert(false, '$e');
			asserts.done();
		}).eager();
		return asserts;
	}

	public function verify_update() {
		checkAddressName(asserts, 'bp_address');
		return asserts;
	}

	public function delete_address() {
		addresses.delete(addressId).next(res -> {
			asserts.assert(res.success);
			asserts.done();
		}).tryRecover(e -> {
			trace(e);
			asserts.assert(false, '$e');
			asserts.done();
		}).eager();
		return asserts;
	}
}

@:asserts
class MailboxTests extends ProxyTestBase {
	var mailboxes(get, never):tink.web.proxy.Remote<UserMailboxProxy>;
	var mailboxId:String;

	inline function get_mailboxes()
		return this.wildDuckProxy.users().get(State.userId).mailboxes();

	public function create_mailbox() {
		mailboxes.create({
			path: 'Some New Mailbox'
		}).next(res -> {
			asserts.assert(res.success);
			mailboxId = res.id;
			asserts.done();
		}).tryRecover(e -> {
			trace(e);
			asserts.assert(false, '$e');
			asserts.done();
		}).eager();
		return asserts;
	}

	public function mailbox_select() {
		mailboxes.select({
			counters: true,
			sizes: true,
			showHidden: true
		}).next(res -> {
			asserts.assert(res.success);
			asserts.assert(res.results.length == 6);
			var boxNames = ['INBOX', 'Drafts', 'Junk', 'Sent Mail', 'Some New Mailbox', 'Trash'];
			res.results.iter(mailbox -> {
				var foundBox = boxNames.find(boxName -> boxName == mailbox.name);
				if (foundBox != null)
					asserts.assert(mailbox.name == foundBox);
				else
					asserts.assert(false, 'Could not find box ${mailbox.name}');
			});
			asserts.done();
		}).tryRecover(e -> {
			trace(e);
			asserts.assert(false, '$e');
			asserts.done();
		}).eager();
		return asserts;
	}

	public function mailbox_update() {
		mailboxes.get(this.mailboxId).update({
			path: 'New Path'
		}).next(res -> {
			asserts.assert(res.success);
			asserts.done();
		}).tryRecover(e -> {
			trace(e);
			asserts.assert(false, '$e');
			asserts.done();
		}).eager();
		return asserts;
	}

	public function mailbox_info() {
		mailboxes.get(this.mailboxId).info().next(res -> {
			asserts.assert(res.success);
			asserts.assert(res.path == "New Path");
			asserts.done();
		}).tryRecover(e -> {
			trace(e);
			asserts.assert(false, '$e');
			asserts.done();
		}).eager();
		return asserts;
	}

	public function delete_mailbox() {
		mailboxes.get(this.mailboxId).delete().next(res -> {
			asserts.assert(res.success);
			asserts.done();
		}).tryRecover(e -> {
			trace(e);
			asserts.assert(false, '$e');
			asserts.done();
		}).eager();
		return asserts;
	}
}
