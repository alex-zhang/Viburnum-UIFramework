package com.viburnum.core.plugins
{
	import com.viburnum.core.SystemStage;
	import com.viburnum.events.DragEvent;
	import com.viburnum.interfaces.IDragOnFly;
	import com.viburnum.interfaces.IMouseCursorDecorator;
	import com.viburnum.interfaces.IPluginEntity;
	import com.viburnum.utils.UpdateAfterEventGloabalControlUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 *  DragOnFly触发开始拖动事件.
	 */	
	[Event(name="dragStart", type="com.viburnum.events.DragEvent")]
	
	/**
	 * DragOnFly结束拖动事件.
	 */	
	[Event(name="dragEnd", type="com.viburnum.events.DragEvent")]
	
	/**
	 * DragOnFly配合CursorDecorator实现拖拽的功能.
	 * 
	 * @author zhangcheng01
	 * 
	 */	
	
	public class DragOnFly extends EventDispatcher implements IDragOnFly
	{
		public var smoothMoing:Boolean = false;
		
		protected var myPluginEntity:IPluginEntity;//ILayerChildrenManager//IPluginEntity//IVirburnumDisplayObject
		
		protected var myStage:Stage;
		protected var myCursorDecorator:IMouseCursorDecorator;
		
		private var _isDragging:Boolean = false;
		
		private var _dragInitiator:Sprite = null;
		private var _dragInitMouseEvent:MouseEvent = null;
		private var _dragImage:DisplayObject = null;
		private var _offsetPoint:Point = null;
		private var _dragImageAlpha:Number = 0.5;
		private var _draggingData:Object = null;
		
		private var _acceptDragDropTargets:Array = [];
		private var _currentDragDrop:DisplayObject = null;
		
		private var _dragStartAppMousePoint:Point = null;
		private var _isDraggingInited:Boolean = false;
		private var _isFirstListenMouseMove:Boolean = false;
		
		private var _isHideCursor:Boolean = false;
		
		private var _cursorDecoratorHandle:uint = 0;
		
		public function DragOnFly()
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
			
			myCursorDecorator = myPluginEntity.getPluinByType(IMouseCursorDecorator) as IMouseCursorDecorator;
		}
		
		public function onDettachFromPluginEntity():void
		{
			endDrag();
			
			myStage = null;
			myCursorDecorator = null;
		}
		
		//IDragOnFly Interface
		/**
		 * 是否处于拖拽状态.
		 * 
		 */		
		public function get isDragging():Boolean
		{
			return _isDragging;
		}
		
		/**
		 * 开始拖拽.
		 * 
		 * @param dragInitiator 拖拽动作的发起者.
		 * @param dragInitMouseEvent 拖拽动作的Mouse发起事件.
		 * @param draggingData 拖拽动作的发起挈带的数据对象.
		 * @param dragImage 拖拽动作的展示对象.
		 * @param offsetPoint 拖拽动作的展示对象的鼠标偏移量.
		 * @param imageAlpha 拖拽动作的展示对象的appha
		 * @param isDragNow 是否在拖拽动作的Mouse发起事件时就发生拖拽显示，还是在之后的MouseMove中发生
		 * @param isAutoDragImage flag表示是否生成dragImage的snapshoot进行拖拽显示.
		 * @param isHideCursor 是否隐藏鼠标指针.
		 * 
		 */		
		public function doDrag(dragInitiator:Sprite,
							   dragInitMouseEvent:MouseEvent, //MOUSE_EVENT.MOUSE_DOWN || MouseEvent.MOUSE_MOVE
							   draggingData:Object = null,
							   dragImage:DisplayObject = null, // instance of dragged item(s)
							   offsetPoint:Point = null,
							   imageAlpha:Number = 0.5,
							   isDragNow:Boolean = false/*default Mouse Move do really drag*/,
							   isAutoDragImage:Boolean = true,
							   isHideCursor:Boolean = false):void
		{
			if(_isDragging || dragInitMouseEvent.type != MouseEvent.MOUSE_DOWN && dragInitMouseEvent.type != MouseEvent.MOUSE_MOVE) return;
			
			_isDragging = true;
			
			_draggingData = draggingData;
			_dragStartAppMousePoint = myStage.globalToLocal(new Point(dragInitMouseEvent.stageX, dragInitMouseEvent.stageY));
			
			_dragInitiator = dragInitiator;
			_dragInitMouseEvent = dragInitMouseEvent;
			
			_isHideCursor = isHideCursor;
			
			if(isAutoDragImage)
			{
				var dragImageBitmapDataW:int = int(dragInitiator.width);
				var dragImageBitmapDataH:int = int(dragInitiator.height);
				var dragImageBitmapData:BitmapData = new BitmapData(dragImageBitmapDataW, dragImageBitmapDataH);
				try
				{
					dragImageBitmapData.draw(dragInitiator);
				}
				catch(error:Error) {};
				
				_dragImage = new Bitmap(dragImageBitmapData);
			}
			else
			{
				_dragImage = dragImage;	
			}
			
			_offsetPoint = offsetPoint;
			_dragImageAlpha = imageAlpha;
			
			myStage.addEventListener(Event.DEACTIVATE, stageMouseDeactivedHandler, false, int.MAX_VALUE, true);
			myStage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler, false, int.MAX_VALUE, true);
			myStage.addEventListener(MouseEvent.MOUSE_OVER, stageMouseOverHandler, false, int.MAX_VALUE, true);
			myStage.addEventListener(MouseEvent.MOUSE_OUT, stageMouseOutHandler, false, int.MAX_VALUE, true);
			myStage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler, false, int.MAX_VALUE, true);
			
			if(isDragNow)
			{
				initializedDrag();
			}
		}
		
		private function initializedDrag():void
		{
			if(_isDraggingInited) return;
			
			_isDraggingInited = true;
			
			if(_dragImage != null)
			{
				_dragImage.alpha = _dragImageAlpha;
			}
			
			if(_offsetPoint == null)
			{
				_offsetPoint = new Point(-_dragInitMouseEvent.localX, -_dragInitMouseEvent.localY);
			}
			
			_cursorDecoratorHandle = myCursorDecorator.setCursorHangingDrop(_dragImage, _offsetPoint, _isHideCursor);	
			
			if(hasEventListener(DragEvent.DRAG_START))
			{
				var dragEvent:DragEvent = new DragEvent(DragEvent.DRAG_START, _dragInitiator, 
					_dragInitMouseEvent, _dragImage, _draggingData);
				this.dispatchEvent(dragEvent);
			}
		}
		
		private function stageMouseDeactivedHandler(event:Event):void
		{
			endDrag();
		}
		
		private function stageMouseMoveHandler(event:MouseEvent):void
		{
			if(!_isFirstListenMouseMove)
			{
				_isFirstListenMouseMove = true;
				
				if(!_isDraggingInited)
				{
					initializedDrag();
				}
			}
			
			var dragEvent:DragEvent = new DragEvent(DragEvent.DRAG_MOVE, _dragInitiator, _dragInitMouseEvent, _dragImage, _draggingData);
			dispatchDragTargetTreelistDragEvent(event.target as IEventDispatcher, dragEvent);
			
			if(smoothMoing) UpdateAfterEventGloabalControlUtil.requetsUpdateAfterEvent(event);
		}
		
		private function dispatchDragTargetTreelistDragEvent(target:IEventDispatcher, dragEvent:DragEvent):void
		{
			try
			{
				if(target != null && target is Sprite && Sprite(target).mouseEnabled)
				{
					if(target.hasEventListener(dragEvent.type))
					{
//						if(dragEvent.type == DragEvent.DRAG_ENTER)
//						{
//							trace(target);
//						}
						
						target.dispatchEvent(dragEvent);
					}
					
					target = Sprite(target).parent;
					
					dispatchDragTargetTreelistDragEvent(target, dragEvent);
				}
			}
			catch(error:Error) {};
		}
		
		private function stageMouseOverHandler(event:MouseEvent):void
		{
			var dragEvent:DragEvent = new DragEvent(DragEvent.DRAG_ENTER, _dragInitiator, _dragInitMouseEvent, _dragImage, _draggingData);
			dispatchDragTargetTreelistDragEvent(event.target as IEventDispatcher, dragEvent);
		}
		
		private function stageMouseOutHandler(event:MouseEvent):void
		{
			var dragEvent:DragEvent = new DragEvent(DragEvent.DRAG_EXIT, _dragInitiator, _dragInitMouseEvent, _dragImage, _draggingData);
			dispatchDragTargetTreelistDragEvent(event.target as IEventDispatcher, dragEvent);
		}
		
		private function stageMouseUpHandler(event:MouseEvent):void
		{
			var target:DisplayObject = event.target as DisplayObject;
			if(isAllowDragDropTarget(target))
			{
				_currentDragDrop = target;
				
				if(target.hasEventListener(DragEvent.DRAG_DROP))
				{
					var dragEvent:DragEvent = new DragEvent(DragEvent.DRAG_DROP, 
						_dragInitiator, _dragInitMouseEvent, _dragImage, _draggingData);
					dragEvent.dragDropTarget = _currentDragDrop;
					target.dispatchEvent(dragEvent);
				}
			}
			
			endDrag();
		}
		
		/**
		 * 接受拖拽释放。
		 *  
		 * @param target
		 * 
		 */		
		public function acceptDragDropTarget(target:DisplayObject):void
		{
			if(target == null) return;
			
			if(!isAllowDragDropTarget(target))
			{
				_acceptDragDropTargets.push(target);
			}
		}
		
		/**
		 * 拒绝拖拽释放
		 *  
		 * @param target
		 * 
		 */		
		public function refuseDragDropTarget(target:DisplayObject):void
		{
			if(target == null) return;
			
			if(isAllowDragDropTarget(target))
			{
				var delIndex:int = _acceptDragDropTargets.indexOf(target);
				_acceptDragDropTargets.splice(delIndex, 1);
			}
		}
		
		/**
		 * 返回该对象是否允许被拖拽释放
		 *  
		 * @param target
		 * @return 
		 * 
		 */		
		public function isAllowDragDropTarget(target:DisplayObject):Boolean
		{
			if(!_isDragging || target == null) return false;
			
			return _acceptDragDropTargets.indexOf(target) != -1;
		}
		
		/**
		 * 结束拖拽行为。 
		 * 
		 */		
		public function endDrag():void
		{
			if(!_isDragging) return;
			
			myCursorDecorator.removeCursorHangingDrop(_cursorDecoratorHandle);
			
			myStage.removeEventListener(Event.DEACTIVATE, stageMouseDeactivedHandler);
			myStage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
			myStage.removeEventListener(MouseEvent.MOUSE_OVER, stageMouseOverHandler);
			myStage.removeEventListener(MouseEvent.MOUSE_OUT, stageMouseOutHandler);
			myStage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
			
			if(hasEventListener(DragEvent.DRAG_END))
			{
				var dragEvent:DragEvent = new DragEvent(DragEvent.DRAG_END, _dragInitiator, _dragInitMouseEvent, _dragImage, _draggingData);
				dragEvent.dragDropTarget = _currentDragDrop;
				this.dispatchEvent(dragEvent);
			}
			
			_isDragging= false;
			
			_dragInitiator = null;
			_dragInitMouseEvent = null;
			_dragImage = null;
			_offsetPoint = null;
			_draggingData = null;
			_isDraggingInited = false;
			_isFirstListenMouseMove = false;
			_acceptDragDropTargets.splice(0, 1);
			_currentDragDrop = null;
		}
	}
}