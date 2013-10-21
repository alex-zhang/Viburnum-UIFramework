package com.viburnum.managers
{
	import com.viburnum.interfaces.IAsyValidatingClient;
	import com.viburnum.interfaces.IPluginComponent;
	import com.viburnum.interfaces.IPluginEntity;
	import com.viburnum.interfaces.IVirburnumDisplayObject;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	public class LayerChildrenManager implements ILayerChildrenManager
	{
		public var host:DisplayObjectContainer
		
		protected var myTopLayer:Sprite;
		protected var myMiddleLayer:Sprite;
		protected var myContentLayer:Sprite;
		
		protected var myLayersLayoutChildren:Vector.<IVirburnumDisplayObject> = 
			new Vector.<IVirburnumDisplayObject>();
		
		public function LayerChildrenManager(host:DisplayObjectContainer)
		{
			super();
			
			this.host = host;
			
			initializeLayers();
		}
		
		protected function initializeLayers():void
		{
			myTopLayer = new Sprite();
			myTopLayer.name = LayerChildrenNames.TOP_LAYER_NAME;
			
			myMiddleLayer = new Sprite();
			myMiddleLayer.name = LayerChildrenNames.MIDDLE_LAYER_NAME;
			
			myContentLayer = new Sprite();
			myContentLayer.name = LayerChildrenNames.CONTENT_LAYER_NAME;
			
			//--
			
			host.addChild(myContentLayer);
			host.addChild(myMiddleLayer);
			host.addChild(myTopLayer);
		}
		
		public function addChildToLayerByLayerName(child:DisplayObject, layerName:String):DisplayObject
		{
			var layer:Sprite = host.getChildByName(layerName) as Sprite;
			
			if(!layer)
				throw new Error("LayerLayoutChildrenManager::addChildToLayerIndex layerName " + layerName + " is Not exsit!");
			
			if(layer.contains(child))
				throw new Error("LayerLayoutChildrenManager::addChildToLayerIndex layerName " + layerName + " child is exist!");
			
			if(host is IPluginEntity && child is IPluginComponent)
			{
				IPluginComponent(child).pluginEntity = IPluginEntity(host);
				IPluginComponent(child).onAttachToPluginEntity();
			}
			
			if(child is IVirburnumDisplayObject)
			{
				var searchIndex:int = myLayersLayoutChildren.indexOf(IVirburnumDisplayObject(child));
				
				if(searchIndex == -1)
				{
					IVirburnumDisplayObject(child).setSize(host.width, host.height);

					myLayersLayoutChildren.push(child);
				}
			}
			
			if(!(layer is IAsyValidatingClient) && 
				(host is IAsyValidatingClient) && 
				(child is IAsyValidatingClient))
			{
				IAsyValidatingClient(child).nestLevel = IAsyValidatingClient(host).nestLevel + 1;
			}
			
			return layer.addChild(child);
		}
		
		public function removeChildFromLayerByLayerName(child:DisplayObject, layerName:String):DisplayObject
		{
			var layer:Sprite = host.getChildByName(layerName) as Sprite;
			
			if(!layer)
				throw new Error("LayerLayoutChildrenManager::addChildToLayerIndex layerName " + layerName + " is Not exsit!");
			
			if(!layer.contains(child))
				throw new Error("LayerLayoutChildrenManager::addChildToLayerIndex layerName " + layerName + " child is not exist!");
			
			if(host is IPluginEntity && child is IPluginComponent)
			{
				IPluginComponent(child).pluginEntity = null;
				IPluginComponent(child).onDettachFromPluginEntity();
			}
			
			if(child is IVirburnumDisplayObject)
			{
				var searchIndex:int = myLayersLayoutChildren.indexOf(IVirburnumDisplayObject(child));
				
				if(searchIndex != -1)
				{
					myLayersLayoutChildren.splice(searchIndex, 1);
				}
			}
			
			return layer.removeChild(child);
		}
		
		public function setSize(newWidth:Number, newHeight:Number):void
		{
			for(var i:int = 0, n:int = myLayersLayoutChildren.length; i < n; i++)
			{
				myLayersLayoutChildren[i].setSize(newWidth, newHeight);
			}
		}
	}
}