package com.viburnum.components
{
    import com.viburnum.components.baseClasses.DividedContainerBase;

    public class HDividedContainer extends DividedContainerBase
    {
        public function HDividedContainer()
        {
            super();

			//defaut must be gap = 0
			myContentGroup = new HGroup();
			HGroup(myContentGroup).gap = 0;
        }
    }
}