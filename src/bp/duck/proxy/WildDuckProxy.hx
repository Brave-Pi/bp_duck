package bp.duck.proxy;

import bp.duck.proxy.models.Requests;
import bp.duck.proxy.models.Results;
import tink.CoreApi;

// 1.) Translate WildDuck API into tink_web proxy interface
interface QuotaResetProxy {
	@:post('/quota/reset')
	var resetQuota:{
        >BasicResult,
        ?storageUsed:Int
    }
}

interface WildDuckProxy extends QuotaResetProxy {
	@:sub('/users')
	var users:UserProxy;
}

interface UserProxy {
	@:post('/')
    function create(body:UserUpsertRequest):UserUpsertResult;
    
    @:get('/resolve/$username')
    function resolve(username:String):UserResolutionResult;
    
	@:sub('/$id')
	function byId(id:String):OwnUserProxy;

	@:get('/')
	function select(body:UserSelectRequest):UserSelectResult;
}

interface OwnUserProxy extends QuotaResetProxy {
    @:get('/')
    function info():UserInfoResult;

	@:delete('/')
    function delete(body:UserDeleteRequest):UserDeleteResult;

    @:put('/')
    function update(body:UserUpdateRequest):BasicResult;
    
	@:put('/logout')
    function logOut(body:UserLogoutRequest):BasicResult;

    @:post('/password/reset') 
    function resetPass(body:PasswordResetRequest):PasswordResetResult;

}
