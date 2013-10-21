package com.viburnum.interfaces
{
	/**
	 * IAsyValidatingClient定义了异步更新的接口.
	 * 
	 * @author zhangcheng01
	 * 
	 */	
	public interface IAsyValidatingClient
	{
		/**
		 * 返回 异步更新对象的优先级。
		 * 
		 * <p>如果是显示对象的话则为层深</p> 
		 * 
		 */		
		function get nestLevel():int;

		/**
		 * 设置异步更新对象的优先级。
		 * 
		 * <p>如果显示对象还有IAsyValidatingClient的Child同时还要更新Child的nestLevel</p>
		 * 
		 */		
		function set nestLevel(value:int):void;
		
		function invalidateProperties():void;
		function invalidateSize():void;
		function invalidateDisplayList():void;

		function validateProperties():void;
		function validateSize():void;
		function validateDisplayList():void;
		function validateNow(skipNestLevel:Boolean = false):void;
	}
}