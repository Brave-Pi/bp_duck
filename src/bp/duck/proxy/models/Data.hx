package bp.duck.proxy.models;

typedef Auditable = {
	?sess:String
}

typedef AddressBase = {
	address:String,
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
	?metaData:Dynamic,
	?hasPasswordSet:Bool,
	?activated:Bool,
	?disabled:Bool,
	?suspended:Bool
};

typedef QuotaBase = {
	allowed:Int,
	used:Int
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
