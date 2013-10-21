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

    public class RSLItem extends EventDispatcher implements IRSListItem
    {
		private var _title:String = "";
		private var _description:String = "";
		private var _url:String = "";
        private var _version:String = "";
		
		private var _loader:Loader = null;
		
		private var _bytesLoaded:uint = 0;
		private var _bytesTotal:uint = 1;
		
		private var _loaded:Boolean = false;
        
        public function RSLItem(title:String = "",
									 description:String = "",
									 version:String = "",
									 url:String = "")
        {
			_title = title;
			_description = description;
            _version = _version;
			_url = url;
        }
		
		public function get title():String
		{
			return _title;
		}
		
		public function get description():String
		{
			return _description;
		}
		
        public function get url():String
        {
            return _url;
        }
        
        public function get version():String
        {
            return _version;
        }
        
		public function get bytesLoaded():uint
		{
			return _bytesLoaded;
		}
		
		public function get bytesTotal():uint
		{
			return _bytesTotal;
		}
		
		public function get loaded():Boolean
		{
			return _loaded;
		}

        public function load():void
        {
			_loaded = false;

			if(!_loader)
			{
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadIOErrorHandler);
				_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
				//test
				_loader.load(new URLRequest(_url + "?ver=" + Math.random()/*_version*/), new LoaderContext(false, ApplicationDomain.currentDomain));
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
		private function loadIOErrorHandler(event:IOErrorEvent):void
		{
			removeLoad();
			
			dispatchEvent(new RSLEvent(RSLEvent.RSL_ERROR));
		}
		
		private function loadProgressHandler(event:ProgressEvent):void
		{
			_bytesLoaded = event.bytesLoaded;
			_bytesTotal = event.bytesTotal;
			
			var rslEvent:RSLEvent = new RSLEvent(RSLEvent.RSL_ITEM_PROGRESS);
			rslEvent.bytesLoaded = _bytesLoaded;
			rslEvent.bytesTotal = _bytesTotal;
			
			dispatchEvent(rslEvent);
		}
		
		private function loadCompleteHandler(event:Event):void
		{
			_loader.unload();
			
			removeLoad();

			_loaded = true;

			dispatchEvent(new RSLEvent(RSLEvent.RSL_ITEM_COMPLETE));
		}
    }
}