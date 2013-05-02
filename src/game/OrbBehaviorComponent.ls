package
{
    import Loom.Animation.EaseType;
    import Loom.Animation.Tween;
    import Loom.GameFramework.LoomGameObject;
    import Loom.GameFramework.TickedComponent;
    import Loom.GameFramework.TimeManager;
    import Loom.Graphics.Point2;
    import Loom2D.Display.Stage;
    
    public delegate OrbDeathCallback(orb:OrbBehaviorComponent, object:LoomGameObject):void;
    
    enum orbType
    {
        Minus = 0,
        Plus,
        NumTypes
    }
    
    public class OrbBehaviorComponent extends TickedComponent
    {
        [Inject]
        protected var _gameLayer:Stage;
        protected var _designWidth:int;
        protected var _designHeight:int;
        
        protected static var textures:Vector.<String> = ["minus.png", "plus.png"];
        public static var colors:Vector.<int> = [0xE12300, 0x36A91B];
        
        protected var _texture:String;
        
        protected var _actor:ActorComponent;
        protected var _alive:Boolean = false;
        
        protected var _type:orbType;
        
        public var onDeath:OrbDeathCallback = new OrbDeathCallback();
        
        public function set texture(value:String)
        {
            _texture = value;
        }
        
        public function get texture():String
        {
            return _texture;
        }
        
        public function get type():orbType
        {
            return _type;
        }
        
        public function get alive():Boolean
        {
            return _alive;
        }
        
        public function OrbBehaviorComponent()
        {
            _type = MathUtils.randomInRange(0, orbType.NumTypes as int) as orbType;
            _texture = textures[_type as int];
        }
        
        override public function onAdd():Boolean
        {
            if (!super.onAdd())
                return false;
                
            _actor = owner.lookupComponentByName("actor") as ActorComponent;
            
            _designWidth = _gameLayer.stageWidth;
            _designHeight = _gameLayer.stageHeight;
            
            _actor.radius = 32;
            _actor.position = MathUtils.randomPoint(100, 100, _designWidth - 100, _designHeight - 100);
            // TODO: Set velocity so we're moving towards open space
            _actor.velocity = MathUtils.randomPoint(10, 10, 100, 100);
            _actor.velocity.x *= MathUtils.randomSign();
            _actor.velocity.y *= MathUtils.randomSign();
            
            Tween.to(_actor, 0.15, { "scale" : 1, "alpha" : 1, "ease" : EaseType.EASE_IN }).onComplete += function()
            {
                _alive = true;
            }
            
            return true;
        }
        
        override public function onRemove()
        {
            super.onRemove();
        }
        
        override public function onTick()
        {
            if (_alive)
            {
                var shouldKill = false;
                if ((_actor.position.x - _actor.radius < 0) ||
                    (_actor.position.x + _actor.radius > _designWidth))
                {
                    _actor.velocity.x *= -1;
                }
                
                if ((_actor.position.y - _actor.radius < 0) ||
                    (_actor.position.y + _actor.radius > _designHeight))
                {
                    _actor.velocity.y *= -1;
                }
                
                if (shouldKill)
                {
                    kill();
                }
            }
        }
        
        public function kill()
        {
            if (!_alive) return;
            
            _alive = false;
            Tween.to(_actor, 0.15, { "scale" : 0, "alpha" : 0, "ease" : EaseType.EASE_OUT }).onComplete += function()
            {
                onDeath(this, owner);
            }
        }
    }
}