package com.viburnum.rsls
{
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.net.URLRequest;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    import flash.utils.getDefinitionByName;

    public class XMLRSLItem extends BasicRSLItemLoader
    {
		private var _loader:Loader = null;
		
        public function XMLRSLItem(itemXML:XML)
        {
			super();
			
			_title = itemXML.@title;
			_description = itemXML.@description;
			_url = itemXML.@url;
        }
		
        override public function load():void
        {
			if(!_loader)
			{
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadIOErrorHandler);
				_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
				
				_loader.load(new URLRequest(_url), new LoaderContext(false, ApplicationDomain.currentDomain));
			}
        }

		private function removeLoad():void
		{
			if(_loader)
			{
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadCompleteHandler);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadIOErrorHandler);
				_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
				_loader = null;
			}
		}
		
		//event handler
		override protected function loadIOErrorHandler(event:IOErrorEvent):void
		{
			removeLoad();
			dispatchEvent(new RSLEvent(RSLEvent.RSL_ERROR));
		}
		
		override protected function loadProgressHandler(event:ProgressEvent):void
		{
			_bytesLoaded = event.bytesLoaded;
			_bytesTotal = event.bytesTotal;
			
			var rslEvent:RSLEvent = new RSLEvent(RSLEvent.RSL_ITEM_PROGRESS);
			rslEvent.bytesLoaded = _bytesLoaded;
			rslEvent.bytesTotal = _bytesTotal;
			dispatchEvent(rslEvent);
		}
		
		override protected function loadCompleteHandler(event:Event):void
		{
			_loader.unload();
			removeLoad();
			_loaded = true;

			dispatchEvent(new RSLEvent(RSLEvent.RSL_ITEM_COMPLETE));
		}
    }
}