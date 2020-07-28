package bp.duck.proxy;

import bp.duck.proxy.models.Requests;
import bp.duck.proxy.models.Results;
import tink.CoreApi;

// 1.) Translate WildDuck API into tink_web proxy interface
interface QuotaResetProxy {
    @:post('/quota/reset')
    @:params(accessToken = header['X-Access-Token'])
	function resetQuota(?accessToken:String):{
        >BasicResult,
        ?storageUsed:Int
    };
}

interface WildDuckProxy extends QuotaResetProxy {


    @:sub('/users')
    @:params(accessToken = header['X-Access-Token'])
    function users(?accessToken:String):UserProxy;
    
    @:sub('/addresses')
    @:params(accessToken = header['X-Access-Token'])
    function addresses(?accessToken:String):AddressProxy;

    

}

interface AddressProxy {
  

    @:get('/resolve/$id')
    function resolve(id:String, query:AddressResolutionRequest):AddressResolutionResult;

    @:get('/')
    function list():RegisteredAddressListResult;

    @:put('/renameDomain')
    function renameDomain(body:RenameDomainRequest):RenameDomainResult;

    @:sub('/forwarded')
    function forwarded():ForwardedAddressProxy;
    
  
}

interface ForwardedAddressProxy {

    @:post('/')
    function create(body:ForwardedAddressCreateResult):ForwardedAddressCreateResult;

    @:delete('/$id')
    function delete(id:String):ForwardedAddressDeleteResult;

    @:get('/$address')
    function get(address:String):ForwardedAddressInfoResult;

    @:put('/$address')
    function update(address:String, body:ForwardedAddressUpdateRequest):ForwardedAddressUpdateResult;
}
interface UserProxy {
	@:post('/')
    function create(body:UserUpsertRequest):UserUpsertResult;
    
    @:get('/resolve/$username')
    function resolve(username:String):UserResolutionResult;
    
	@:sub('/$id')
	function get(id:String):OwnUserProxy;

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

    @:sub('/addresses')
    function addresses():UserAddressProxy;
}

interface UserAddressProxy {
    @:post('/')
    function create(body:UserAddressCreateRequest):UserAddressCreateResult;
    

    @:delete('/$id')
    function delete(id:String):UserAddressDeleteResult;


    @:get('/')
    function list():UserAddressListResult;

    @:get('/$id')
    function get(id:String):AddressInfoResult;

    @:put('/$id')
    function update(id:String, body:AddressUpdateRequest):AddressUpdateResult;

}
