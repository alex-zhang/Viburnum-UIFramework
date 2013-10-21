package com.viburnum.utils
{
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;

	public final class ApplicationDomainUtil
	{
		private static var _applicationDomainMap:Array = [];
		
		public static function registApplicationDomain(applicationDomainName:String, applicationDomain:ApplicationDomain):void
		{
			if(!_applicationDomainMap[applicationDomainName])
			{
				_applicationDomainMap[applicationDomainName] = applicationDomain;
			}
			else
			{
				throw new Error("ApplicationDomainUtil::registApplicationDomain " + applicationDomainName + " is exsit!");
			}
		}
		
		public static function unRegistApplicationDomain(applicationDomainName:String):void
		{
			if(_applicationDomainMap[applicationDomainName])
			{
				delete _applicationDomainMap[applicationDomainName];
			}
			else
			{
				throw new Error("ApplicationDomainUtil::unRegistApplicationDomain " + applicationDomainName + " is'nt exsit!");
			}
		}

		public static function hasRegistApplicationDomain(applicationDomainName:String):Boolean
		{
			return _applicationDomainMap[applicationDomainName];
		}
		
		public static function getRegistApplicationDomain(applicationDomainName:String):ApplicationDomain
		{
			return _applicationDomainMap[applicationDomainName] as ApplicationDomain;
		}
		
		public static function getDefinitionByName(name:String, applicationDomainName:String = null):Object
		{
			if(applicationDomainName == null)
			{
				return flash.utils.getDefinitionByName(name);
			}

			var applicationDomain:ApplicationDomain = getRegistApplicationDomain(applicationDomainName);
			
			if(applicationDomain != null)
			{
				applicationDomain = _applicationDomainMap[applicationDomainName];
				
				return applicationDomain.getDefinition(name);
			}
			
			return null;
		}
	}
}