package com.viburnum.interfaces
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 *  IDragOnFly触发开始拖动事件.
	 */	
	[Event(name="dragStart", type="com.viburnum.events.DragEvent")]
	
	/**
	 * IDragOnFly结束拖动事件.
	 */	
	[Event(name="dragEnd", type="com.viburnum.events.DragEvent")]
	
	/**
	 * IDragOnFly定义实现拖拽功能的的接口.
	 * 
	 * <p>配合ISystemStage 中提供的层次结构 实现鼠标拖拽对象展示的功能。</p>
	 * 
	 * @author winnie
	 * 
	 */	
	
	public interface IDragOnFly extends IEventDispatcher, IPluginComponent
	{
		/**
		 * 当前是否正在拖动
		 * 
		 */		
		function get isDragging():Boolean;
		
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
		function doDrag(dragInitiator:Sprite,
						dragInitMouseEvent:MouseEvent, //MOUSE_EVENT.MOUSE_DOWN || MouseEvent.MOUSE_MOVE
						draggingData:Object = null,
						dragImage:DisplayObject = null, // instance of dragged item(s)
						offsetPoint:Point = null,
						imageAlpha:Number = 0.5,
						isDragNow:Boolean = false/*default Mouse Move do really drag*/,
						isAutoDragImage:Boolean = true,
						isHideCursor:Boolean = false):void;
		
		function acceptDragDropTarget(target:DisplayObject):void;
		function refuseDragDropTarget(target:DisplayObject):void;
		function isAllowDragDropTarget(target:DisplayObject):Boolean;
		
		function endDrag():void;
	}
}