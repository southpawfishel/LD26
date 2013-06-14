package
{
	import loom.animation.EaseType;
	import loom.animation.Tween;
	import loom.gameframework.LoomGameObject;
	import loom.gameframework.TickedComponent;
	import loom2d.display.Stage;
    import loom2d.Loom2D;
    
    public delegate OrbDeathCallback(orb:OrbBehaviorComponent, object:LoomGameObject):void;
    
    enum orbType
    {
        Minus = 0,
        Plus,
        NumTypes
    }
    
    public class OrbBehaviorComponent extends TickedComponent
    {
        protected var _designWidth:int;
        protected var _designHeight:int;
        
        protected static var textures:Vector.<String> = ["minus", "plus"];
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
            
            _designWidth = Loom2D.stage.stageWidth;
            _designHeight = Loom2D.stage.stageHeight;
            
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