package com.viburnum.layouts
{
	import com.viburnum.interfaces.IAsyValidatingClient;
	import com.viburnum.utils.LayoutUtil;
	
	import com.viburnum.interfaces.ILayoutElement;
	
	//完全代理Layout的度量和布局,且被布局对象必须没有任何边界
	public class LayoutBase
	{
		protected var myLayoutHost:ILayoutHost;

		private var _typicalLayoutElement:ILayoutElement;
		private var _typicalLayoutElementChangedFlag:Boolean = false;

		public function LayoutBase()
		{
			super();
		}

		public function get layoutHost():ILayoutHost
		{
			return myLayoutHost;
		}

		public function set layoutHost(value:ILayoutHost):void
		{
			if(myLayoutHost != value)
			{
				resetLayoutCache();

				myLayoutHost = value;
			}
		}
		
		protected function get realLayoutHost():ILayoutHost
		{
			return myLayoutHost as ILayoutHost;
		}
		
		protected function get virtualLayoutHost():IVirtualLayoutHost
		{
			return myLayoutHost as IVirtualLayoutHost;
		}
		
		//当被布局的对象变更时，重置上次缓存的布局信息
		protected function resetLayoutCache():void
		{
			_typicalLayoutElement = null;
		}

		public function get typicalLayoutElement():ILayoutElement
		{
			return _typicalLayoutElement;
		}

		public function set typicalLayoutElement(value:ILayoutElement):void
		{
			_typicalLayoutElement = value;
		}
		
		public final function measure():void
		{
			if(myLayoutHost == null) return;
			
			if(myLayoutHost is IVirtualLayoutHost)
			{
				virtualMeasure();
			}
			else
			{
				realMeasure();
			}
		}
		
		public final function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			if(myLayoutHost == null) return;
			
			if(myLayoutHost is IVirtualLayoutHost)
			{
				virtualUpdateDisplayList(layoutWidth, layoutHeight);	
			}
			else
			{
				realUpdateDisplayList(layoutWidth, layoutHeight);
			}
		}
		
		protected function virtualMeasure():void
		{
		}
		
		protected function realMeasure():void
		{
		}
		
		protected function virtualUpdateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
		}
		
		protected function realUpdateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
		}
	}
}