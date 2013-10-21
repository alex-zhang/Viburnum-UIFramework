package com.viburnum.lang
{
	import com.viburnum.components.IApplication;
	import com.viburnum.interfaces.IPluginEntity;
	import com.viburnum.lang.ILangManager;
	import com.alex.utils.StringUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	
	public class LangManager extends EventDispatcher implements ILangManager
	{
		protected var myApplication:IApplication;
		
		//{zh_CN : {Alert: {yse: XXX, no: XXX }}}
		private var _localeMap:Object = {};// {zh_CN : {Alert: ResourceBundle }}
		private var _locale:String = ""; /* of String zh_CN,en_US...*/;

		public function LangManager()
		{
			super();
		}
		
		//IPluginComponent Interface
		public function get pluginEntity():IPluginEntity
		{
			return myApplication;
		}
		
		public function set pluginEntity(value:IPluginEntity):void
		{
			myApplication = value as IApplication;
		}
		
		public function onAttachToPluginEntity():void
		{
		}
		
		public function onDettachFromPluginEntity():void
		{
		}

		public function get locale():String
		{
			return _locale;
		}

		//[zh_CN, en_US]
		public function set locale(value:String):void
		{
			_locale = value;
		}

		public function loadResourceModule(url:String, update:Boolean = true, applicationDomain:ApplicationDomain = null, securityDomain:SecurityDomain = null):IEventDispatcher
		{
			return null;
		}
		
		public function addResourceBundle(resourceBundle:LangBundle):void
		{
			if(resourceBundle == null || resourceBundle.locale == null || resourceBundle.bundleName == null) return;

			var locale:String = resourceBundle.locale;
			var bundleName:String = resourceBundle.bundleName;
			
			var exitBundle:LangBundle = findBundle(bundleName, locale);
			if(exitBundle == null)
			{
				var bundles:* = _localeMap[locale];
				if(bundles == undefined) 
				{
					bundles = {};
					_localeMap[locale] = bundles;
				}

				bundles[bundleName] = resourceBundle;
			}
			else
			{
				exitBundle.mergeBundle(resourceBundle);
			}
		}
		
		public function removeResourceBundle(locale:String, bundleName:String):void
		{
			if(_localeMap[locale] != undefined && _localeMap[locale][bundleName] != undefined)
			{
				delete Object(_localeMap[locale])[bundleName];
			}
		}
		
		public function removeResourceBundlesForLocale(locale:String):void
		{
			if(_localeMap[locale] != undefined)
			{
				delete Object(_localeMap)[locale];
			}
		}
		
		public function update():void
		{
			//must has listener
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function getLocales():Array /* of String */
		{
			var locales:Array = [];
			for (var p:String in _localeMap)
			{
				locales.push(p);
			}

			return locales;
		}
		
		public function getBundleNamesForLocale(locale:String):Array /* of String */
		{
			var bundleNameArr:Array = [];
			for (var localeS:String in _localeMap)
			{
				if(localeS == locale)
				{
					var bundles:Object = _localeMap[localeS];
					for(var bundleNameS:String in bundles)
					{
						bundleNameArr.push(bundleNameS);
					}
					break;
				}
			}

			return bundleNameArr;
		}
		
		public function initializeLocaleChain(locale:String, bundlesResourceChain:Object):void
		{
			if(locale == null || bundlesResourceChain == null) return;
			
			if(!_locale || _locale == "") _locale = locale; 

			var hasLocaleDefinded:Boolean = _localeMap[locale] != undefined;
			
			var bundles:Object = {};
			for(var bundleNameS:String in bundlesResourceChain)
			{
				var bundle:LangBundle;
				
				var newBundle:LangBundle = new LangBundle(locale, bundleNameS, bundlesResourceChain[bundleNameS]);
				if(hasLocaleDefinded)
				{
					var exsitBundle:LangBundle = findBundle(bundleNameS, locale);
					if(exsitBundle != null && !(exsitBundle.isEmpty()))
					{
						exsitBundle.mergeBundle(newBundle);
						bundle = exsitBundle;
					}
				}
				else//ini new
				{
					bundle = newBundle;
				}
				
				bundles[bundleNameS] = bundle;
			}
			
			_localeMap[locale] = bundles;
		}
		
		public function getObject(bundleName:String, resourceName:String, locale:String = null):*
		{
			var resourceBundle:LangBundle = findBundle(bundleName, locale);
			if (resourceBundle == null) return undefined;

			return resourceBundle.content[resourceName];
		}
		
		public function getString(bundleName:String, resourceName:String, parameters:Array = null, locale:String = null):String
		{
			var resourceBundle:LangBundle = findBundle(bundleName, locale);
			if (resourceBundle == null) return null;
			
			var value:String = String(resourceBundle.content[resourceName]);
			
			if (parameters)
			{
				value = StringUtil.substitute(value, parameters);
			}
			
			return value;
		}
		
		public function getStringArray(bundleName:String, resourceName:String, locale:String = null):Array /* of String */
		{
			var resourceBundle:LangBundle = findBundle(bundleName, locale);
			if (resourceBundle == null) return null;
			
			var value:* = resourceBundle.content[resourceName];
			
			var array:Array = String(value).split(",");
			
			var n:int = array.length;
			for (var i:int = 0; i < n; i++)
			{
				array[i] = StringUtil.trim(array[i]);
			}  

			return array;
		}
		
		public function getNumber(bundleName:String, resourceName:String, locale:String = null):Number
		{
			var resourceBundle:LangBundle = findBundle(bundleName, locale);
			if (resourceBundle == null) return NaN;
			
			var value:* = resourceBundle.content[resourceName];
			
			return Number(value);
		}
		
		public function getInt(bundleName:String, resourceName:String, locale:String = null):int
		{
			var resourceBundle:LangBundle = findBundle(bundleName, locale);
			if (resourceBundle == null) return 0;
			
			var value:* = resourceBundle.content[resourceName];
			
			return int(value);
		}
		
		public function getUint(bundleName:String, resourceName:String, locale:String = null):uint
		{
			var resourceBundle:LangBundle = findBundle(bundleName, locale);
			if (resourceBundle == null) return 0;
			
			var value:* = resourceBundle.content[resourceName];
			
			return uint(value);
		}
		
		public function getBoolean(bundleName:String, resourceName:String, locale:String = null):Boolean
		{
			var resourceBundle:LangBundle = findBundle(bundleName, locale);
			if (resourceBundle == null) return false;
			
			var value:* = resourceBundle.content[resourceName];
			
			return String(value).toLowerCase() == "true";
		}
		
		public function getClass(bundleName:String, resourceName:String, locale:String = null):Class
		{
			var resourceBundle:LangBundle = findBundle(bundleName, locale);
			if (resourceBundle == null) return null;
			
			var value:* = resourceBundle.content[resourceName];

			return value as Class;
		}
		
		private function findBundle(bundleName:String, locale:String):LangBundle
		{
			if(locale == null) locale = _locale;

			for (var localeS:String in _localeMap)
			{
				if(localeS == locale)
				{
					var bundles:Object = _localeMap[localeS];
					for(var bundleNameS:String in bundles)
					{
						if(bundleNameS == bundleName)
						{
							return bundles[bundleNameS];
						}
					}
				}
			}

			return null;
		}
	}
}