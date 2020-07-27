package bp.duck.proxy.models;


typedef Auditable = {
	?sess:String
}


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
