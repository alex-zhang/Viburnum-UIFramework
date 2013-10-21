package
{
	import com.viburnum.core.IAssetsFactory;
	import com.viburnum.core.SystemStage;
	import com.viburnum.interfaces.ISystemStageChild;
	import com.viburnum.rsls.ConfigXMLRSLsLoader;
	import com.viburnum.rsls.IRSLsLoader;
	import com.viburnum.rsls.RSLEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	public class ViburnumBootStrap extends SystemStage
	{
		public function ViburnumBootStrap()
		{
			super();
		}

		override protected function initRSLListLoader():void
		{
			var rslloader:IRSLsLoader = new ConfigXMLRSLsLoader("rsl.xml");
			rslloader.addEventListener(RSLEvent.RSL_COMPLETE, rslCompleteHandler);
			rslloader.addEventListener(RSLEvent.RSL_ERROR, rslErrorHandler);
			rslloader.addEventListener(RSLEvent.RSL_PROGRESS, rslProgress);
			rslloader.load();
		}
		
		private function rslCompleteHandler(e:RSLEvent):void
		{
			return;
			var mainLoader:Loader = new Loader();
			mainLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
			mainLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);
			var mainloadContext:LoaderContext = null;//new LoaderContext(false, )
			mainLoader.load(new URLRequest("../../main/bin-debug/ViburnumBootStrapMain.swf"), mainloadContext);
		}
		
		private function loaderErrorHandler(event:IOErrorEvent):void
		{
		}
		
		private function loadCompleteHandler(event:Event):void
		{
			var loadInfo:LoaderInfo = LoaderInfo(event.target);
			var loader:Loader = loadInfo.loader;
			var appchild:ISystemStageChild = ISystemStageChild(loadInfo.content);
			addSystemStageChild(appchild);
		}
		
		private function rslProgress(e:RSLEvent):void
		{
			trace("rslProgress", e.bytesLoaded, e.bytesTotal);
		}
		
		private function rslErrorHandler(e:RSLEvent):void
		{
			trace("rslErrorHandler");
		}
	}
}