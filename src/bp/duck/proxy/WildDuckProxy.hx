package bp.duck.proxy;
import bp.duck.proxy.models.Requests;
import bp.duck.proxy.models.Results;
// 1.) Translate WildDuck API into tink_web proxy interface
interface WildDuckProxy {
    @:sub('/users')
    var users:UserProxy;
}

interface UserProxy {
    @:post('/')
    @:params(request = body)
    function create(request:UserUpsertRequest):UserUpsertResult;
    @:sub('/$id')
    function byId(id:Int):OwnUserProxy;
    @:get('/')
    @:params(request = body)
    function select(request:UserSelectRequest):UserSelectResult;

}

interface OwnUserProxy {
    @:delete('/')
    function delete(body:UserDeleteRequest):UserDeleteResult;
    @:put('/logout')
    function logOut(body:UserLogoutRequest):BasicResult;
}
