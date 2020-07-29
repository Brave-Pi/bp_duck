package bp.duck.proxy;


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
    function users(?accessToken:String):UsersProxy;
    
    @:sub('/addresses')
    @:params(accessToken = header['X-Access-Token'])
    function addresses(?accessToken:String):AddressProxy;

    @:sub('/audit')
    @:params(accessToken = header['X-Access-Token'])
    function audit(?accessToken:String):AuditsProxy;

    @:sub('/auth')
    @:params(accessToken = header['X-Access-Token'])
    function auth(?accessToken:String):AuthProxy;

    @:sub('/dkim')
    @:params(accessToken = header['X-Access-Token'])
    function dkim(?accessToken:String):DkimsProxy;

    @:sub('/domainaliases')
    @:params(accessToken = header['X-Access-Token'])
    function domainAliases(?accessToken:String):DomainAliasesProxy;

}

interface DomainAliasesProxy {
    @:post('/')
    function create(body:DomainAliasCreateRequest):DomainAliasCreateResult;

    @:sub('$id')
    function get(id:String):DomainAliasProxy;

    @:get('/')
    function list():DomainAliasListResult;

    @:get('/resolve/$alias')
    function resolve(alias:String):DomainAliasResolutionResult;
}

interface DomainAliasProxy {
    @:delete('/')
    function delete():DomainAliasDeleteResult;

    @:get('/')
    function info():DomainAliasInfoResult;
}

interface DkimsProxy {
    @:post('/')
    function create(body:DkimCreateRequest):DkimCreateResult;

    @:sub('/$id')
    function get(id:String):DkimProxy;

    @:get('/')
    function list(query:DkimListRequest):DkimListResult;

    @:get('/resolve/$domain')
    function resolve(domain:String):DkimResolutionResult;
}

interface DkimProxy {
    @:delete('/')
    function delete():DkimDeleteResult;

    @:get('/')
    function info():DkimInfoResult;
}

interface AuthProxy {
    @:post('/')
    function login(body:AuthenticateRequest):AuthenticateResult;

    @:delete('/')
    function logout():AuthInvalidateResult;
}

interface AuditsProxy {
    @:post('/audit')
    function create(body:AuditCreateRequest):AuditCreateResult;

    @:sub('/$id')
    function get(id:String):AuditProxy;
}

interface AuditProxy {
    @:get('/export.mbox')
    function download():AuditExportResult;

    @:get('/')
    function info():AuditInfoResult;
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
interface UsersProxy {
	@:post('/')
    function create(body:UserUpsertRequest):UserUpsertResult;
    
    @:get('/resolve/$username')
    function resolve(username:String):UserResolutionResult;
    
	@:sub('/$id')
	function get(id:String):UserProxy;

	@:get('/')
	function select(body:UserSelectRequest):UserSelectResult;
}

interface UserProxy extends QuotaResetProxy {
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
    
    @:post('/submit')
    function submitMessage(body:SubmitMessageRequest):DraftSubmitResult;

    @:sub('/authlog')
    function authlog():AuthLogProxy;

    @:sub('/addresses')
    function addresses():UserAddressProxy;
    
    @:sub('/mailboxes')
    function mailboxes():UserMailboxProxy;

    @:get('/search')
    function selectMail(query:MessageSelectRequest):MessageSelectResult;

    @:sub('/storage')
    function storage():StorageProxy;
    
    @:sub('/2fa')
    function twoFactorAuth():TwoFactorAuthProxy;

    @:sub('/asps')
    function asps():ASPsProxy;

    @:sub('/archived')
    function archives():ArchiveProxy;   

    @:sub('/autoreply')
    function autoreply():AutoReplyProxy;

    @:sub('/filters')
    function filters():FiltersProxy;
}

interface FiltersProxy {
    @:post('/')
    function create(body:FilterCreateRequest):FilterCreateResult;

    @:sub('/$id')
    function get(id:String):FilterProxy;

    @:get('/')
    function list():FilterListResult;
}

interface FilterProxy {
    @:delete('/')
    function delete():FilterDeleteResult;

    @:get('/')
    function info():FilterInfoResult;

    @:put('/')
    function update(body:FilterUpdateRequest):FilterUpdateResult;
}

interface AutoReplyProxy {
    @:delete('/')
    function delete():AutoReplyDeleteResult;

    @:get('/')
    function info():AutoReplyInfoResult;

    @:put('/')
    function update(body:AutoReplyUpdateRequest):AutoReplyUpdateResult;
}


interface AuthLogProxy {
    @:get('/')
    function list(query:AuthLogListRequest):AuthLogListResult;

    @:get('/$id')
    function get(id:String):AuthLogResult;
}

interface ArchiveProxy {
    @:sub('messages')
    function messages():ArchiveMessagesProxy;

    @:post('/restore')
    function restore(body:ArchiveBulkRestoreRequest):ArchiveBulkRestoreResult;
}

interface ArchiveMessagesProxy {
    @:get('/')
    function list(query:ArchiveListRequest):ArchiveListResult;

    @:post('/$message/restore')
    function restore(message:Int, body:ArchiveRestoreRequest):ArchiveRestoreResult;

}

interface ASPsProxy {
    @:post('/')
    function create(body:ASPCreateRequest):ASPCreateResult;

    @:sub('/$id')
    function get(id:String):ASPProxy;

    @:get('/')
    function list(query:ASPListRequest):ASPListResult;
}

interface ASPProxy {
    @:delete('/')
    function delete():ASPDeleteResult;

    @:get('/')
    function info():ASPInfoResult;
}


interface TwoFactorAuthProxy {
    @:delete('/')
    function disable(query:TwoFactorAuthDisableRequest):TwoFactorAuthDisableResult;

    @:delete('/totp')
    function disableTotp(query:TwoFactorAuthTotpDisableRequest):TwoFactorAuthTotpDisableResult;

    @:delete('/custom')
    function disableCustom(query:CustomTwoFactorAuthDisableRequest):CustomTwoFactorAuthDisableResult;

    @:post('/enable')
    function enable(body:TwoFactorAuthEnableRequest):TwoFactorAuthEnableResult;

    @:put('/custom')
    function enableCustom(body:CustomTwoFactorAuthEnableRequest):CustomTwoFactorAuthEnableResult;

    @:post('/totp/setup')
    function generateTotpSeed(body:TwoFactorAuthGenSeedRequest):TwoFactorAuthGenSeedResult;

    @:post('/totp/check')
    function validateTotpToken(body:TwoFactorAuthValidateRequest):TwoFactorAuthValidateResult;
}

interface StorageProxy {
    @:sub('/$id')
    function get(id:String):FileProxy;
    @:get('/')
    function list(query:FileListRequest):FileListResult;
    
}

interface FileProxy {
    @:delete
    function delete():FileDeleteResult;
    @:get
    function download():FileDownloadResult;
    @:post
    function create(body:RealSource, query:FileUploadRequest):FileUploadResult;

}

interface UserMailboxProxy {
    @:post('/')
    function create(body:MailboxCreateRequest):MailboxCreateResult;

    
    @:get('/')
    function select(body:MailboxSelectRequest):MailboxSelectResult;
    @:sub('/$id')
    function get(id:String):MailboxProxy;

    
}

interface MailboxProxy {
    @:delete('/')
    function delete():MailboxDeleteResult;

    @:get('/')
    function info():MailboxInfoResult;

    @:put('/')
    function update(body:MailboxUpdateRequest):MailboxUpdateResult;

    @:sub('/messages')
    function messages():MessagesProxy;
}

interface MessagesProxy {

    @:delete('/')
    function deleteAll(query:MessagesDeleteRequest):MessagesDeleteResult;

    @:sub('/$id')
    function get(id:String):MessageProxy;

    @:get('/')
    function list(query:MessageListRequest):MessageListResult;

    @:put('/')
    function update(body:MessageUpdateRequest):MessageUpdateResult;

    @:post('/')
    function create(body:DraftCreateRequest):DraftSubmitResult;
}

interface MessageProxy {
    @:delete('/')
    function delete():MessageDeleteResult;

    @:sub('/attachments')
    function attachments():AttachmentProxy;

    @:post('/forward')
    function forward(query:MessageForwardRequest):MessageForwardResult;

    @:get('/message.eml')
    function download():MessageDownloadResult;

    @:get('/')
    function info(query:MessageInfoRequest):MessageInfoResult;

    @:post('/submit')
    function submit(body:DraftSubmitRequest):DraftSubmitResult;

    

}

interface AttachmentProxy {
    @:get('/$id')
    function download(id:String):AttachmentDownloadResult;

    
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
