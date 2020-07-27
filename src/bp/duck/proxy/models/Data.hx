package bp.duck.proxy.models;

typedef UserBase = {
	?id:String,
	?username:String,
	?name:String,
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
