package
{
    import Loom.GameFramework.TickedComponent;
    import Loom.GameFramework.TimeManager;
    import Loom.Graphics.Point2;
    
    public class ActorComponent extends TickedComponent
    {
        protected var _position:Point2 = new Point2(0, 0);
        protected var _velocity:Point2 = new Point2(0, 0);
        protected var _scale:Number = 0;
        protected var _radius:Number = 0;
        protected var _r:int = 255, _g:int = 255, _b:int = 255;
        protected var _opacity:int = 0;
        
        public function ActorComponent()
        {
        }
        
        public function set x(value:Number)
        {
            _position.x = value;
        }
        
        public function get x():Number
        {
            return _position.x;
        }
        
        public function set y(value:Number)
        {
            _position.y = value;
        }
        
        public function get y():Number
        {
            return _position.y;
        }
        
        public function set position(value:Point2)
        {
            _position = value;
        }
        
        public function get position():Point2
        {
            return _position;
        }
        
        public function setPosition(x:Number, y:Number)
        {
            this.x = x;
            this.y = y;
        }
        
        public function set velocity(value:Point2)
        {
            _velocity = value;
        }
        
        public function get velocity():Point2
        {
            return _velocity;
        }
        
        public function set radius(value:Number)
        {
            _radius = value;
        }
        
        public function get radius():Number
        {
            return _radius;
        }
        
        public function set scale(value:Number)
        {
            _scale = value;
        }
        
        public function get scale():Number
        {
            return _scale;
        }
        
        public function set opacity(value:int)
        {
            _opacity = value;
        }
        
        public function get opacity():int
        {
            return _opacity;
        }
        
        public function get r():int { return _r; };
        public function get g():int { return _g; };
        public function get b():int { return _b; };
        
        public function set r(value:int):void { _r = value; };
        public function set g(value:int):void { _g = value; };
        public function set b(value:int):void { _b = value; };
        
        public function get scaledRadius():Number
        {
            return scale * radius;
        }
        
        public override function onTick()
        {
            _position.x += _velocity.x * timeManager.TICK_RATE;
            _position.y += _velocity.y * timeManager.TICK_RATE;
            //_position = _position + MathUtils.scalePoint(_velocity, timeManager.TICK_RATE);
        }
        
        public function collidesWithComponent(otherComponent:ActorComponent):Boolean
        {
            var distanceSquared = MathUtils.squareDistance(_position, otherComponent.position);
            var collisionDistance = (scaledRadius + otherComponent.scaledRadius) * (scaledRadius + otherComponent.scaledRadius);
            //trace("actual distance: " + distanceSquared + " collision distance: " + collisionDistance);
            return distanceSquared < collisionDistance;
        }
        
        public function pointWithinRadius(x:Number, y:Number):Boolean
        {
            var point = new Point2();
            point.x = x;
            point.y = y;
            
            var distanceSquared = MathUtils.subtractPoint(_position, point).getSquareMagnitude();
            var collisionDistance = scaledRadius * scaledRadius;
            var collided = distanceSquared < collisionDistance;
            //trace("actual distance: " + distanceSquared + " collision distance: " + collisionDistance);
            return distanceSquared < collisionDistance;
        }
    }
}