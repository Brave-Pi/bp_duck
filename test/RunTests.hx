package;

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
		Runner.run(TestBatch.make([new Test(),]), reporter).handle(Runner.exit);
	}
}

@:asserts
class Test {
	public function new() {}

	var container:LocalContainer;
	var wildDuckProxy:bp.duck.Proxy;

	// var duckSvcProxy:bp.duck

	@:setup
	public function setup() {
		// var container = new LocalContainer();
		// var router = new Router<bp.DuckSvc>(new bp.DuckSvc());
		// container.run(req -> router.route(Context.ofRequest(req)).recover(OutgoingResponse.reportError));
		var client = new NodeClient();
		wildDuckProxy = new bp.duck.Proxy(client, new RemoteEndpoint(new Host('localhost', 8080)));
		trace('setup');
		return Noise;
	}

	var userId:String;

	public function create_user() {
		var random = Std.random(100000);
		var request = {
			username: 'test$random',
			password: "someSecret",
			address: 'test$random@brave-pi.io',
		};
		trace(request);
		wildDuckProxy.users().create(request).next(res -> {
			asserts.assert(res.success);

			userId = res.id;

			asserts.done();
		}).tryRecover(e -> {
			trace(e);
			asserts.assert(e == null);
			asserts.done();
		}).eager();

		return asserts;
	}

	public function user_reset_quota() {
		wildDuckProxy.users().byId(userId).resetQuota().next(res -> {
			asserts.assert(res.success);
			asserts.assert(res.storageUsed == 0);
			asserts.done();
		}).tryRecover(e -> {
			trace(e);
			asserts.assert(e == null);
			asserts.done();
		}).eager();
		return asserts;
	}

	public function user_info() {
		wildDuckProxy.users().byId(userId).info().next(res -> {
			asserts.assert(res.success);
			asserts.done();
		}).tryRecover(e -> {
			trace(e);
			asserts.assert(e == null);
			asserts.done();
		}).eager();
		return asserts;
	}

	var newPass:String;

	public function reset_pass() {
		wildDuckProxy.users().byId(userId).resetPass({
			sess: "tink_unittest session",
			ip: "127.0.0.1"
		}).next(res -> {
			asserts.assert(res.success);

			newPass = res.password;

			asserts.done();
		}).tryRecover(e -> {
			trace(e);
			asserts.assert(e == null);
			asserts.done();
		}).eager();
		return asserts;
	}
}
