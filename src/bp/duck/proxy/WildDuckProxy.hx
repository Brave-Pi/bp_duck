package bp.duck.proxy;

import bp.duck.proxy.models.Requests;
import bp.duck.proxy.models.Results;
import tink.CoreApi;

// 1.) Translate WildDuck API into tink_web proxy interface
interface QuotaResetProxy {
	@:post('/quota/reset')
	var resetQuota:Noise;
}

interface WildDuckProxy extends QuotaResetProxy {
	@:sub('/users')
	var users:UserProxy;
}

interface UserProxy {
	@:post('/')
	@:params(request = body)
	function create(request:UserUpsertRequest):UserUpsertResult;

	@:sub('/$id')
	function byId(id:String):OwnUserProxy;

	@:get('/')
	@:params(request = body)
	function select(request:UserSelectRequest):UserSelectResult;
}

interface OwnUserProxy extends QuotaResetProxy {
    @:get('/')
    function info():UserInfoResult;
	@:delete('/')
	function delete(body:UserDeleteRequest):UserDeleteResult;
	@:put('/logout')
	function logOut(body:UserLogoutRequest):BasicResult;
	// @:post('/quota/reset')
	// var resetQuota:Noise;
}
