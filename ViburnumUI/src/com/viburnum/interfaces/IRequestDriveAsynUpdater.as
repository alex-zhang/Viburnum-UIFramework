package com.viburnum.interfaces
{
	import flash.display.Stage;

	/**
	 * 异步更新器接口.
	 *  
	 * @author zhangcheng01
	 * 
	 */	
    public interface IRequestDriveAsynUpdater
    {
		function setStage(stage:Stage):void;
		
		/**
		 * 提交属性异步更新请求.
		 *  
		 * @param target
		 * 
		 */		
        function invalidateProperties(target:IAsyValidatingClient):void;
		
		/**
		 * 提交尺寸异步更新请求
		 * 
		 * @param target
		 * 
		 */		
        function invalidateSize(target:IAsyValidatingClient):void;
		
		/**
		 * 提交显示列表异步更新请求
		 * 
		 * @param target
		 * 
		 */	
        function invalidateDisplayList(target:IAsyValidatingClient):void;
		
		/**
		 * 同步更新所有.
		 *  
		 * @param target
		 * @param skipNestLevel
		 * 
		 */		
		function validateNow(target:IAsyValidatingClient = null, skipNestLevel:Boolean = false):void;
		
		/**
		 * 返回 更新器是否处于失效状态，需要在更新.
		 */		
		function isInvalid():Boolean;
    }
}