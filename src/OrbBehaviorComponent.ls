package
{
    import Loom.GameFramework.TickedComponent;
    import Loom.GameFramework.TimeManager;
    import Loom.Graphics.Point2;
    
    import cocos2d.CCScaledLayer;
    
    public class OrbBehaviorComponent extends TickedComponent
    {
        [Inject]
        protected var _gameLayer:CCScaledLayer;
        
        protected var _actor:ActorComponent;
        protected var _texture:String;
        protected var _alive:Boolean = true;
        
        public function set actor(value:ActorComponent)
        {
            _actor = value;
        }
        
        public function set texture(value:String)
        {
            _texture = value;
        }
        
        public function get texture():String
        {
            return _texture;
        }
        
        public function OrbBehaviorComponent()
        {
        }
        
        public override function onTick()
        {
            if (_alive)
            {
                if (_actor.position.x < 0)
                {
                    trace("actor exit stage left");
                    _alive = false;
                }
                else if (_actor.position.x > _gameLayer.designWidth)
                {
                    trace("actor exit stage right");
                    _alive = false;
                }
                else if (_actor.position.y < 0)
                {
                    trace("actor exit stage down");
                    _alive = false;
                }
                else if (_actor.position.y > _gameLayer.designHeight)
                {
                    trace("actor exit stage up");
                    _alive = false;
                }
                
                if (!_alive)
                    owner.destroy();
            }
        }
    }
}