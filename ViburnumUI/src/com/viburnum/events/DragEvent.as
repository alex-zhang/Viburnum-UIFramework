package com.viburnum.events
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	public class DragEvent extends Event
	{
		public static const DRAG_START:String = "dragStart";//DragManager be dispatch
		public static const DRAG_DROP:String = "dragDrop";//DragManager be dispatch
		public static const DRAG_END:String = "dragEnd";//DragManager be dispatch

		public static const DRAG_MOVE:String = "dragMove";//dragTarget be dispatch
		public static const DRAG_ENTER:String = "dragEnter";//dragTarget be dispatch
		public static const DRAG_EXIT:String = "dragExit";//dragTarget be dispatch

		public var dragInitiator:Sprite = null;
		public var dragInitMouseEvent:MouseEvent = null;
		public var draggingImage:DisplayObject = null;
		public var draggingData:Object = null;

		public var dragDropTarget:DisplayObject = null;

		public function DragEvent(type:String,
								  dragInitiator:Sprite = null,
								  dragInitMouseEvent:MouseEvent = null, //MOUSE_EVENT.MOUSE_DOWN || MouseEvent.MOUSE_MOVE
								  draggingImage:DisplayObject = null, // instance of dragged item(s)
								  draggingData:Object = null)
		{
			super(type);
			
			this.dragInitiator = dragInitiator;
			this.dragInitMouseEvent = dragInitMouseEvent;
			this.draggingImage = draggingImage;
			this.draggingData = draggingData;
		}
		
		override public function clone():Event
		{
			var cloneEvent:DragEvent = new DragEvent(type, 
													dragInitiator, 
													dragInitMouseEvent, 
													draggingImage, 
													draggingData);
			
			cloneEvent.dragDropTarget = this.dragDropTarget;
			return cloneEvent;
		}
	}
	
}
