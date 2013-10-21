package com.viburnum.components
{
	import com.viburnum.components.baseClasses.VisualAssetLoaderBase;
	
	import flash.display.Loader;
	import flash.net.URLRequest;

	public class ImageLoader extends VisualAssetLoaderBase
	{
		public function ImageLoader()
		{
			super();
		}
		
		override public function set source(value:Object):void
		{
			checkIsValidURLValue(value);
			
			super.source = value;
		}
		
		override public function load(url:Object=null):void
		{
			checkIsValidURLValue(url);
			
			super.load(url);
		}
		
		//url 可以为Null
		private function checkIsValidURLValue(url:Object = null):void
		{
			if(url != null && !(url is String)) throw new Error("Invalid value Type, must String Type");
		}
		
		override protected function onLoadContent(source:Object):void
		{
			if(source == null) return;
			
			//这里source一定是String
			if(contentHolder == null)
			{
				contentHolder = new Loader();
				addChild(contentHolder);
			}
			
			super.onLoadContent(null);
			
			Loader(contentHolder).load(new URLRequest(source.toString()), loaderContext);
		}
	}
}