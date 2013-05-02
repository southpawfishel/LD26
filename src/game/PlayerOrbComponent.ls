package
{
    import CocosDenshion.SimpleAudioEngine;
    import Loom.Animation.EaseType;
    import Loom.Animation.Tween;
    import Loom.GameFramework.LoomGameObject;
    import Loom.GameFramework.TickedComponent;
    import Loom.GameFramework.TimeManager;
    import Loom.Graphics.Point2;
    import Loom2D.Display.Stage;
    import Loom2D.Events.Event;
    import Loom2D.Events.TouchEvent;
    import Loom2D.Math.Color;
    
    public delegate PlayerOrbDeathCallback(orb:PlayerOrbComponent, object:LoomGameObject):void;
    public delegate PolarityChangedCallback(polarity:int):void;
    
    public class PlayerOrbComponent extends TickedComponent
    {
        [Inject]
        protected var _gameLayer:Stage;
        protected var _designWidth:int;
        protected var _designHeight:int;
        
        protected var _texture:String;
        
        protected var _actor:ActorComponent;
        protected var _alive:Boolean = false;
        
        protected var _trackingDrag:Boolean = false;
        protected var _trackingDragId:Object = null;
        
        public static var GOOD_SFX = "assets/boop.wav";
        public static var BAD_SFX = "assets/beep.wav";
        
        protected var _polarity:int = 0;
        
        public var onDeath:PlayerOrbDeathCallback = new PlayerOrbDeathCallback();
        public var onPolarityChanged:PolarityChangedCallback = new PolarityChangedCallback();
        
        public function set texture(value:String)
        {
            _texture = value;
        }
        
        public function get texture():String
        {
            return _texture;
        }
        
        public function PlayerOrbComponent()
        {
            texture = "whiteorb.png";
        }
        
        override public function onAdd():Boolean
        {
            if (!super.onAdd())
                return false;
                
            _actor = owner.lookupComponentByName("actor") as ActorComponent;
            _actor.radius = 35;
                
            _gameLayer.addEventListener(Event.TOUCH_DOWN, onTouchBegan);
            // TODO
            //_gameLayer.onTouchMoved += onTouchMoved;
            //_gameLayer.onTouchEnded += onTouchEnded;
            
            _designWidth = _gameLayer.stageWidth;
            _designHeight = _gameLayer.stageHeight;
            
            return true;
        }
        
        override public function onRemove()
        {
            _gameLayer.removeEventListener(Event.TOUCH_DOWN, onTouchBegan);
            // TODO
            //_gameLayer.onTouchMoved -= onTouchMoved;
            //_gameLayer.onTouchEnded -= onTouchEnded;
            
            super.onRemove();
        }
        
        override public function onTick()
        {
            _actor.position.x = Math.clamp(_actor.position.x, _actor.scaledRadius, _designWidth - _actor.scaledRadius);
            _actor.position.y = Math.clamp(_actor.position.y, _actor.scaledRadius, _designHeight - _actor.scaledRadius);
        }
        
        public function onTouchBegan(event:TouchEvent, object:Object)
        {
            if (_trackingDrag) return;
            if (_alive && !_actor.pointWithinRadius(event.x, event.y)) return;
            
            if (!_alive)
            {
                Tween.to(_actor, 0.15, { "scale" : 1, "alpha" : 1, "ease" : EaseType.EASE_IN }).onComplete += function()
                {
                    _alive = true;
                }
            }
            
            _trackingDrag = true;
            _trackingDragId = object;
            _actor.setPosition(event.x, event.y);
        }
        
        protected function onTouchMoved(id:int, touchX:Number, touchY:Number)
        {
            if (_trackingDragId != id) return;
            
            _actor.setPosition(touchX, touchY);
        }
        
        protected function onTouchEnded(id:int, touchX:Number, touchY:Number)
        {
            if (_trackingDrag && _trackingDragId == id)
            {
                _trackingDrag = false;
                _trackingDragId = null;
            }
        }
        
        public function handleCollisionWithOrb(orb:LoomGameObject)
        {
            var behavior = orb.lookupComponentByName("behavior") as OrbBehaviorComponent;
            if (!behavior || !behavior.alive) return;
            
            // Update our polarity
            if (_polarity == 0)
            {
                if (behavior.type == orbType.Plus) ++_polarity;
                else if (behavior.type == orbType.Minus) --_polarity;
                SimpleAudioEngine.sharedEngine().playEffect(BAD_SFX);
            }
            else if (_polarity > 0)
            {
                if (behavior.type == orbType.Plus)
                {
                    SimpleAudioEngine.sharedEngine().playEffect(GOOD_SFX);
                    ++_polarity;
                }
                else if (behavior.type == orbType.Minus)
                {
                    SimpleAudioEngine.sharedEngine().playEffect(BAD_SFX);
                    --_polarity;
                }
            }
            else
            {
                if (behavior.type == orbType.Plus)
                {
                    SimpleAudioEngine.sharedEngine().playEffect(GOOD_SFX);
                    ++_polarity;
                }
                else if (behavior.type == orbType.Minus)
                {
                    SimpleAudioEngine.sharedEngine().playEffect(BAD_SFX);
                    --_polarity;
                }
            }
            
            onPolarityChanged(_polarity);
            
            // Determine our dominant color based on what we've absorbed
            var dominantColor = new Color(255, 255, 255, 255);
            if (_polarity < 0)
            {
                dominantColor = Color.fromInteger(OrbBehaviorComponent.colors[0]);
            }
            else if (_polarity > 0)
            {
                dominantColor = Color.fromInteger(OrbBehaviorComponent.colors[1]);
            }
            
            // Scale based on our polarity
            var newScale = 1.0 + (0.1 * Math.abs(_polarity));
            
            // Tween to these new values
            Tween.to(_actor, 0.2, { "r" : dominantColor.red, "g" : dominantColor.green, "b" : dominantColor.blue, "scale" : newScale });
            
            // Kill the orb we collided with
            behavior.kill();
        }
    }
}
