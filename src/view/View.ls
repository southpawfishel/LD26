package UI
{
    import Loom2D.Display.DisplayObjectContainer;

    public delegate ViewCallback():void;

    /**
     * Base view class; convenience callbacks to trigger transitions and 
     * sequence adding/removing from parent.
     */
    class View extends DisplayObjectContainer
    {
        public var onEnter:ViewCallback;
        public var onExit:ViewCallback;

        public function enter(parent:DisplayObjectContainer):void
        {
            parent.addChild(this);
            onEnter();
        }

        public function exit():void
        {
            if(parent)
            {
                parent.removeChild(this);
                onExit();
            }
        }

    }
}