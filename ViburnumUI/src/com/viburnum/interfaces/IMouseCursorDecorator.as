package com.viburnum.interfaces
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	/**
	 * ICursorDecorator接口定义了鼠标指针装饰器的属性和方法。
	 * @author zhangcheng01
	 * 
	 */	
	public interface IMouseCursorDecorator extends IPluginComponent
	{
		/**
		 * 获取鼠标指针装饰器的显示对象。 
		 * 
		 */		
		function getCursorHangingDrop(id:uint):DisplayObject;
		
		/**
		 * 该鼠标指针装饰器是否为当前鼠标指针装饰器.
		 *  
		 * @param id
		 * @return 
		 * 
		 */		
		function isCurrentCursorHangingDrop(id:uint):Boolean;
		
		/**
		 * 该鼠标指针装饰堆栈中是否有指定Id的是否有鼠标指针装饰器.
		 * 
		 * @param id
		 * @return 
		 * 
		 */		
		function hasSetCursorHangingDrop(id:uint):Boolean;
		
		/**
		 * 设置当前鼠标指针装饰器.
		 * 
		 * @param 当前显示的对象
		 * @param 显示偏移量
		 * @param 是否隐藏鼠标指针
		 * @return 返回一个唯一数字标识符handle,0表示无效值
		 */		
		function setCursorHangingDrop(cursorHangingDrop:Object, offset:Point = null, 
									  isHideCursor:Boolean = false):uint;
		
		/**
		 * 移除指定鼠标指针装饰器. 
		 * @param id
		 * 
		 */		
		function removeCursorHangingDrop(id:uint):void;
		
		/**
		 * 更新当前鼠标指针装饰器的显示对象. 
		 * @param id
		 * @param cursorHangingDrop
		 * 
		 */			
		function updateCurrentCursorHangingDrop(id:uint, cursorHangingDrop:Object):void;
	}
}