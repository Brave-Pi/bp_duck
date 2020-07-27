package;

import bp.duck.proxy.models.Requests;
import bp.duck.proxy.models.Results;
import tink.http.containers.*;
import tink.http.Response;
import tink.web.routing.*;
import tink.http.clients.*;
import tink.web.proxy.Remote;
import tink.url.Host;
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
		Runner.run(TestBatch.make([new Test(),])).handle(Runner.exit);
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
		wildDuckProxy.users().create(request).next(u -> {
			asserts.assert(u != null && ({
				userId = u.id;
			}).attempt(true));

			asserts.done();
		}).tryRecover(e -> {
			trace(e);
			asserts.assert(e == null);
			asserts.done();
		}).eager();

		return asserts;
	}

	public function user_reset_quota() {
		wildDuckProxy.users().byId(userId).resetQuota().next(_ -> {
			asserts.assert(true);
			asserts.done();
		}).tryRecover(e -> {
			trace(e);
			asserts.assert(e == null);
			asserts.done();
		}).eager();
		return asserts;
	}
	public function user_info() {
		wildDuckProxy.users().byId(userId).info().next(info -> {
			asserts.assert(info != null);
			asserts.done();
		}).tryRecover(e -> {
			trace(e);
			asserts.assert(e == null);
			asserts.done();
		}).eager();
		return asserts;
	}

}
