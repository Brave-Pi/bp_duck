package bp.duck.proxy.models;

typedef BasicResult = {
    ?success:Bool,
    ?error:String
}

typedef UserUpsertResult = {
	> BasicResult,
	id:String,
}

typedef UserDeleteResult = BasicResult;

typedef PaginatedResult = {
	total:Int,
	page:Int,
	previousCursor:String,
	nextCursor:String,
};

typedef UserSelectResult = {
	> BasicResult,
	> PaginatedResult,
	results:Array<{
		id:String,
		username:String,
		name:String,
		address:String,
		tags:Array<String>,
		targets:Array<String>,
		enabled2fa:Array<String>,
		autoreply:Bool,
		encryptMessages:Bool,
		encryptForwarded:Bool,
		quota:{
			allowed:Int,
			used:Int
		},
		?metaData:Dynamic,
		hasPasswordSet:Bool,
		activated:Bool,
		disabled:Bool,
		suspended:Bool
	}>,
}
