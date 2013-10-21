package com.viburnum.lang
{
	public class LangBundle
	{
		private var _locale:String;
		private var _bundleName:String;
		private var _content:Object = {};

		public function LangBundle(locale:String = null, bundleName:String = null, content:Object = null)
		{
			super();

			_locale = locale;
			_bundleName = bundleName;
			
			_content = content != null ? content : {};
		}  

		public function get bundleName():String
		{
			return _bundleName;
		}

		public function get content():Object
		{
			return _content;
		}

		public function get locale():String
		{
			return _locale;
		}

		//覆盖当前 不会被覆盖已经定义的,只会继承没有定义的undefined
		public function mergeBundle(r:LangBundle):void
		{
			if(r == null || r.isEmpty()) return;
			
			var cotnent:Object = r.content;
			for(var s:String in cotnent)
			{
				if(_content[s] === undefined)
				{
					_content[s] = cotnent[s];    
				}
			}
		}

		public function isEmpty():Boolean
		{
			for(var s:String in _content)
			{
				return false;
			}
			
			return true;
		}
	}
}
