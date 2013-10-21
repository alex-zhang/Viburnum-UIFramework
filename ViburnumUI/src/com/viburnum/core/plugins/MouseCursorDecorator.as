package com.viburnum.core.plugins
{
	import com.viburnum.managers.ILayerChildrenManager;
	import com.viburnum.managers.LayerChildrenNames;
	import com.viburnum.core.SystemStage;
	import com.alex.utils.IFactory;
	import com.viburnum.interfaces.IMouseCursorDecorator;
	import com.viburnum.interfaces.IPluginComponent;
	import com.viburnum.interfaces.IPluginEntity;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;

	/**
	 * CursorDecorator是一个鼠标指针装饰器, 用于管理跟随鼠标指针的显示对象.
	 *  
	 * 在CursorDecorator内部维持了一个指针队列，当最上层的跟随鼠标指针的显示对象
	 * 被移除后才会显示下面的。
	 * 
	 * CursorDecorator的显示在SystemStage中的鼠标层。
	 * 
	 * @author zhangcheng01
	 * 
	 */	
	public class MouseCursorDecorator implements IMouseCursorDecorator
	{
		protected var myStage:Stage;
		protected var myMouseCursorLayer:Sprite;
		
		protected var myPluginEntity:IPluginEntity;//ILayerChildrenManager//IPluginEntity//IVirburnumDisplayObject
		
		private var _isMouseMoveListen:Boolean = false;
		private var _hangingDropInfoStack:Vector.<CursorHangingDropInfo> = new Vector.<CursorHangingDropInfo>();
		private var _currentCursorHangingDropInfo:CursorHangingDropInfo = null;
		private var _cursorHangingDropHandleCount:uint = 0;
		
		public function MouseCursorDecorator()
		{
			super();
		}
		
		//IPluginComponent Interface
		public function get pluginEntity():IPluginEntity
		{
			return myPluginEntity;
		}
		
		public function set pluginEntity(value:IPluginEntity):void
		{
			myPluginEntity = value;
		}
		
		public function onAttachToPluginEntity():void
		{
			myStage = DisplayObject(myPluginEntity).stage;
			
			if(!myMouseCursorLayer) myMouseCursorLayer = createMouseCursorLayer();
			
			ILayerChildrenManager(myPluginEntity).addChildToLayerByLayerName(myMouseCursorLayer, LayerChildrenNames.TOP_LAYER_NAME);
		}
		
		protected function createMouseCursorLayer():Sprite
		{
			var s:Sprite = new Sprite();
			s.name = "MouseCursorDecorator_mouseCursorLayer";
			s.mouseEnabled = false;
			s.mouseChildren = false;
			s.tabEnabled = false;
			s.tabChildren = false;
			return s;
		}
		
		/**
		 * @private
		 * 
		 * 一般不回移除的。 
		 * 
		 */		
		public function onDettachFromPluginEntity():void
		{
			ILayerChildrenManager(myPluginEntity).removeChildFromLayerByLayerName(myMouseCursorLayer, LayerChildrenNames.TOP_LAYER_NAME);
			myMouseCursorLayer.removeChildren();
			removeCursorHangingDropByCurrentInfo();
			myStage = null;
		}
		
		//IMouseCursorDecorator Interface
		/**
		 * 获取鼠标指针装饰器的显示对象。 
		 * 
		 */		
		public function getCursorHangingDrop(id:uint):DisplayObject
		{
			if(id == 0) return null;
			
			if(hasSetCursorHangingDrop(id))
			{
				var n:uint = _hangingDropInfoStack.length;
				for(var i:uint = 0; i < n; i++)
				{
					var cinfo:CursorHangingDropInfo = _hangingDropInfoStack[i];
					if(cinfo.id == id) return cinfo.cursorHangingDrop;
				}
			}
			
			return null;
		}
		
		/**
		 * 该鼠标指针装饰器是否为当前鼠标指针装饰器.
		 *  
		 * @param id
		 * @return 
		 * 
		 */		
		public function isCurrentCursorHangingDrop(id:uint):Boolean
		{
			if(id == 0) return false;
			
			if(_currentCursorHangingDropInfo != null)
			{
				return _currentCursorHangingDropInfo.id == id;
			}
			
			return false;
		}
		
		/**
		 * 该鼠标指针装饰堆栈中是否有指定Id的是否有鼠标指针装饰器.
		 * 
		 * @param id
		 * @return 
		 * 
		 */	
		public function hasSetCursorHangingDrop(id:uint):Boolean
		{
			if(id == 0) return false;
			
			var n:uint = _hangingDropInfoStack.length;
			for(var i:uint = 0; i < n; i++)
			{
				var cinfo:CursorHangingDropInfo = _hangingDropInfoStack[i];
				if(cinfo.id == id) return true;
			}
			
			return false;
		}
		
		/**
		 * 设置当前鼠标指针装饰器。
		 * 
		 * @param 当前显示的对象DisplayObject Class IFactory
		 * @param 显示偏移量
		 * @param 是否隐藏鼠标指针
		 * @return 返回一个唯一数字标识符handle
		 */		
		public function setCursorHangingDrop(cursorHangingDrop:Object, offset:Point = null, 
											 isHideCursor:Boolean = false):uint
		{
			var targetHangingDrop:DisplayObject = generateCursorHangingDropByValue(cursorHangingDrop);
			if(targetHangingDrop != null)
			{
				var handleId:uint = getNewCursorHangingDropHandle();
				
				var cinfo:CursorHangingDropInfo = new CursorHangingDropInfo();
				cinfo.id = handleId;
				cinfo.cursorHangingDrop = targetHangingDrop;
				cinfo.isHideCursor = isHideCursor;
				if(offset == null) offset = new Point();
				cinfo.cursorHangingDropOffset = offset;
				
				_hangingDropInfoStack.push(cinfo);
				
				setAndShowCurrentCursorHangingDropByInfo(cinfo);
				
				return handleId;
			}
			
			return 0;//invalidte
		}
		
		private function setAndShowCurrentCursorHangingDropByInfo(cinfo:CursorHangingDropInfo):void
		{
			if(_currentCursorHangingDropInfo != null)//invisible the last
			{
				_currentCursorHangingDropInfo.cursorHangingDrop.visible = false;
				_currentCursorHangingDropInfo = null;
			}
			
			_currentCursorHangingDropInfo = cinfo;
			
			add2showCursorHangingDropInDisplayList(_currentCursorHangingDropInfo.cursorHangingDrop, true);
			
			if(_currentCursorHangingDropInfo.isHideCursor)
			{
				Mouse.hide();
			}
			else
			{
				Mouse.show();
			}
			
			addMouseMoveListen();
		}
		
		private function add2showCursorHangingDropInDisplayList(hangingDrop:DisplayObject, isCurrent:Boolean):void
		{
			if(!myMouseCursorLayer.contains(hangingDrop))
			{
				addCursorHangingDropToDisplayList(hangingDrop);
			}
			
			hangingDrop.visible = isCurrent;
			
			if(isCurrent)
			{
				updateCurrentCursorHangingDropPostion();
			}
		}
		
		private function removeCursorHangingDropByCurrentInfo():void
		{
			if(_currentCursorHangingDropInfo != null)
			{
				var cursorHangingDrop:DisplayObject = _currentCursorHangingDropInfo.cursorHangingDrop;
				removeCursorHangingDropFromDisplayList(cursorHangingDrop);
				
				if(_currentCursorHangingDropInfo.isHideCursor)
				{
					Mouse.show();
				}
				
				_currentCursorHangingDropInfo = null;
			}
		}
		
		/**
		 * 移除指定鼠标指针装饰器. 
		 * @param id
		 * 
		 */		
		public function removeCursorHangingDrop(id:uint):void
		{
			if(!hasSetCursorHangingDrop(id)) return;
			
			//delete
			var n:uint = _hangingDropInfoStack.length;
			for(var i:uint = 0; i < n; i++)
			{
				var cinfo:CursorHangingDropInfo = _hangingDropInfoStack[i];
				if(cinfo.id == id)
				{
					_hangingDropInfoStack.splice(i, 1);
					removeCursorHangingDropByCurrentInfo();
					break;
				}
			}
			
			//remove then show next
			if(_hangingDropInfoStack.length > 0)
			{
				setAndShowCurrentCursorHangingDropByInfo(CursorHangingDropInfo(_hangingDropInfoStack[_hangingDropInfoStack.length - 1]));
			}
			else if(_hangingDropInfoStack.length == 0)
			{
				removeMouseListen();
			}
		}
		
		/**
		 * 更新当前鼠标指针装饰器的显示对象. 
		 * @param id
		 * @param cursorHangingDrop
		 * 
		 */			
		public function updateCurrentCursorHangingDrop(id:uint, cursorHangingDrop:Object):void
		{
			if(hasSetCursorHangingDrop(id))
			{
				var lastHangingDrop:DisplayObject = getCursorHangingDrop(id);
				removeCursorHangingDropFromDisplayList(lastHangingDrop);
				
				var targetHangingDrop:DisplayObject = generateCursorHangingDropByValue(cursorHangingDrop);
				
				var n:uint = _hangingDropInfoStack.length;
				for(var i:uint = 0; i < n; i++)
				{
					var cinfo:CursorHangingDropInfo = _hangingDropInfoStack[i];
					if(cinfo.id == id)
					{
						cinfo.cursorHangingDrop = targetHangingDrop;
						break;
					}
				}
				
				add2showCursorHangingDropInDisplayList(targetHangingDrop, isCurrentCursorHangingDrop(id));
			}
		}
		
		private function generateCursorHangingDropByValue(cursorHangingDrop:Object/*DisplayObject Class IFactory*/):DisplayObject
		{
			if(cursorHangingDrop is Class || cursorHangingDrop is IFactory)
			{
				if(cursorHangingDrop is Class)
				{
					return generateCursorHangingDropByValue(new cursorHangingDrop());
				}
				else
				{
					return generateCursorHangingDropByValue(IFactory(cursorHangingDrop).newInstance());
				}
			}
			else if(cursorHangingDrop is DisplayObject)
			{
				return DisplayObject(cursorHangingDrop);
			}
			
			return null;
		}
		
		private function addCursorHangingDropToDisplayList(cursorHangingDrop:DisplayObject):void
		{
			if(cursorHangingDrop == null) return;
			
			if(!myMouseCursorLayer.contains(cursorHangingDrop))
			{
				myMouseCursorLayer.addChild(cursorHangingDrop);	
			}
		}
		
		private function removeCursorHangingDropFromDisplayList(cursorHangingDrop:DisplayObject):void
		{
			if(cursorHangingDrop == null) return;
			
			if(cursorHangingDrop is MovieClip)
			{
				MovieClip(cursorHangingDrop).stop();
			}
			
			if(myMouseCursorLayer.contains(cursorHangingDrop))
			{
				myMouseCursorLayer.removeChild(cursorHangingDrop);
			}
		}
		
		private function stageMoveHandler(event:MouseEvent):void
		{
			updateCurrentCursorHangingDropPostion();
			
			event.updateAfterEvent();
		}
		
		private function updateCurrentCursorHangingDropPostion():void
		{
			if(_currentCursorHangingDropInfo != null)
			{
				var cursorHangingDrop:DisplayObject = _currentCursorHangingDropInfo.cursorHangingDrop;
				var cursorHangingDropOffset:Point = _currentCursorHangingDropInfo.cursorHangingDropOffset;
				
				cursorHangingDrop.x = myStage.mouseX + cursorHangingDropOffset.x;
				cursorHangingDrop.y = myStage.mouseY + cursorHangingDropOffset.y;
			}
		}
		
		private function addMouseMoveListen():void
		{
			if(!_isMouseMoveListen)
			{
				_isMouseMoveListen = true;
				
				myStage.addEventListener(MouseEvent.MOUSE_MOVE, stageMoveHandler, false, int.MAX_VALUE, true);
			}
		}
		
		private function removeMouseListen():void
		{
			if(_isMouseMoveListen)
			{
				_isMouseMoveListen = false;
				
				myStage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMoveHandler);
			}
		}
		
		private function getNewCursorHangingDropHandle():uint
		{
			if(_cursorHangingDropHandleCount == uint.MAX_VALUE)
			{
				_cursorHangingDropHandleCount = 1;
			}
			else
			{
				_cursorHangingDropHandleCount++;
			}
			
			return _cursorHangingDropHandleCount;
		}
	}
}

import flash.display.DisplayObject;
import flash.geom.Point;

internal class CursorHangingDropInfo
{
	public var id:uint = 0;
	public var isHideCursor:Boolean = false;
	public var cursorHangingDrop:DisplayObject = null;
	public var cursorHangingDropOffset:Point = null;
}