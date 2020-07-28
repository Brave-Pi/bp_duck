package bp.duck.proxy.models;


typedef Auditable = {
	?sess:String,
	?ip:String
}

typedef HasMeta = {
	?metaData:DynamicAccess<Dynamic>
}

typedef AddressBase = {
	?address:String,
	?name:Dynamic,
	?tags:Array<String>,
	?main:Bool,
	?allowWildcard:Bool
}

typedef ForwardedAddressBase = {
	> AddressBase,
	?targets:Array<String>,
}

typedef AutoReply = {
	?status:Bool,
	?name:String,
	?subject:String,
	?text:String,
	?html:String
};

typedef UserBase = {
	> HasMeta,
	?id:String,
	?username:String,
	?name:String,
	?password:String,
	?address:String,
	?tags:Array<String>,
	?targets:Array<String>,
	?enabled2fa:Array<String>,
	?autoreply:Bool,
	?encryptMessages:Bool,
	?encryptForwarded:Bool,
	?hasPasswordSet:Bool,
	?activated:Bool,
	?disabled:Bool,
	?suspended:Bool
};

typedef QuotaBase = {
	?allowed:Int,
	?used:Int
};

typedef AddressProfileBase = {
	?address:String,
	?main:Bool,
	?name:String
}

typedef MailboxBase = {
	?hidden:Bool,
	?retention:Int,
	?path:String,
	?subscribed:Bool,
}

typedef Mailbox = {
	> MailboxBase,
	@:optional
	var name(default, null):String;
	@:optional
	var specialUse(default, null):String;
	@:optional
	var modifyIndex(default, null):Int;
	@:optional
	var total(default, null):Int;
	@:optional
	var unseen(default, null):Int;
}

typedef Party = {
	?from:String,
	?address:String
}

typedef ContentType = {
	?value:String,
	?params:DynamicAccess<String>
}

typedef MessageBase = {
	> HasMeta,
	?id:Int,
	?mailbox:String,
	?thread:String,
	?from:Party,
	?to:Party,
	?cc:Party,
	?bcc:Party,
	?subject:String,
	?date:String,
	?size:Int,
	?intro:String,
	?seen:Bool,
	?deleted:Bool,
	?flagged:Bool,
	?answered:Bool,
	?forwarded:Bool,
	?contentType:ContentType,
}

typedef MessageHead = {
	> MessageBase,
	?attachments:Bool,
}

typedef FdBase = {
	?id:String,
	?filename:String,
	?contentType:String,
}

typedef MessageInfo<AttachmentType, FileType> = {
	> MessageBase,

	?envelope:{
		from:String,
		rcpt:Array<{value:String, formatted:String}>
	},
	?messageId:String,
	?date:String,
	?list:{
		id:String,
		unsubscribe:String
	},
	?expires:String,
	?seen:Bool,
	?deleted:Bool,
	?flagged:Bool,
	?draft:Bool,
	?html:Array<String>,
	?text:String,
	?headers:Array<{key:String, value:String}>,
	?attachments:Array<AttachmentType>,
	?verificationResults:{
		tls:{
			name:String,
			version:String
		},
		spf:String,
		dkim:String
	},
	?contentType:ContentType,
	?reference:{
		?mailbox:String,
		?id:Int,
		?action:String,
		?attachments:Bool
	},
	?files:Array<FileType>
}

typedef ASPBase = {
	?description:String,
	?scope:Array<String>
}

typedef AuditBase<DateType> = {
	?start:DateType,
	?end:DateType,
	?expires:DateType
}

typedef AutoReplyBase<DateType> = {
	?status:Bool,
	?name:String,
	?subject:String,
	?html:String,
	?text:String,
	?start:DateType,
	?end:DateType
}

typedef DkimBase = {
	?domain:String,
	?selector:String,
	?description:String
}
typedef PrivateDkimBase = {
	>DkimBase,
	?privateKey:String
}

typedef PublicDkimBase = {
	>DkimBase,
	?fingerprint:String,
	?publicKey:String,
}

typedef FilterBase<QueryType,ActionType> = {
	?name:String,
	?query:QueryType,
	?action:ActionType,
	?disabled:Bool
}

typedef QueryInfo = {
	?from:String,
	?to:String,
	?subject:String,
	?listId:String,
	?text:String,
	?ha:Bool,
	?size:Int
}

typedef ActionInfo = {
	?seen:Bool,
	?flag:Bool,
	?delete:Bool,
	?spam:Bool,
	?mailbox:Bool,
	?targets:Bool,
}

typedef FilterInfo = FilterBase<QueryInfo,ActionInfo>;

typedef Filter = FilterBase<Array<String>,Array<String>>;

typedef DomainAlias = {
	?alias:String,
	?domain:String
}
