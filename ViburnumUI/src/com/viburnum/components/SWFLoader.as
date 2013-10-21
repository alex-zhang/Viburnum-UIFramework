package com.viburnum.components
{
	import com.viburnum.components.baseClasses.VisualAssetLoaderBase;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

    public class SWFLoader extends VisualAssetLoaderBase
    {
		private var _source:Object;//Class(BitmapData, Bitmap, Displayobject) BitmapData Bitmap ByteArray String(url)
		private var _sourceChangedFlag:Boolean = false;
		
        public function SWFLoader()
        {
            super();
        }
		
		override protected function onLoadContent(source:Object):void
		{
			if(source == null) return;
			
			var loadContentSource:Object;

			if(source is Class)
			{
				loadContentSource = new source();
			}
			else
			{
				loadContentSource = source;
			}
			
			//BitmapData, Bitmap, Displayobject, ByteArray String(url)
			if(loadContentSource is BitmapData)
			{
				contentHolder = new Bitmap(BitmapData(loadContentSource));
			}
			else if(loadContentSource is Bitmap || contentHolder is DisplayObject)
			{
				contentHolder = DisplayObject(loadContentSource);
			}
			else if(loadContentSource is ByteArray)
			{
				contentHolder = new Loader();
				super.onLoadContent(null);
				Loader(contentHolder).loadBytes(ByteArray(loadContentSource), loaderContext);
			}
			else if(loadContentSource is String)
			{
				contentHolder = new Loader();
				super.onLoadContent(null);
				Loader(contentHolder).load(new URLRequest(loadContentSource.toString()), loaderContext);
			}

			if(contentHolder != null)
			{
				addChild(contentHolder);
			}
		}
		
		override protected function onUnloadContent():void
		{
			if(contentHolder != null)
			{
				if(contentHolder is Bitmap)
				{
					Bitmap(contentHolder).bitmapData.dispose();
					Bitmap(contentHolder).bitmapData = null;
				}
				else if(contentHolder is MovieClip)
				{
					MovieClip(contentHolder).stop();
				}
				else
				{
					super.onUnloadContent();
				}
				
				removeChild(contentHolder);
				contentHolder = null;
			}
		}
	}
}