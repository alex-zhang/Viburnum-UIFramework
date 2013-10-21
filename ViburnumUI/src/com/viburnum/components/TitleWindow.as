package com.viburnum.components
{
	import com.viburnum.events.CloseEvent;

    public class TitleWindow extends Panel
    {
		private var _allowCloseWhenPopup:Boolean = true;

        public function TitleWindow()
        {
            super();
        }
		
		public function get allowCloseWhenPopup():Boolean
		{
			return _allowCloseWhenPopup;
		}
		
		[Inspectable(type="Boolean", defaultValue="true")]
		public function set allowCloseWhenPopup(value:Boolean):void
		{
			_allowCloseWhenPopup = value;
		}
		
		override protected function onInitializeComplete():void
		{
			super.onInitializeComplete();
			
			this.addEventListener(CloseEvent.CLOSE, closeHandler);
		}
		
		private function closeHandler(event:CloseEvent):void
		{
			if(allowCloseWhenPopup && isPopUp)
			{
				if(popupManager != null)
				{
					popupManager.removePopUp(this);
				}
			}
		}
    }
}