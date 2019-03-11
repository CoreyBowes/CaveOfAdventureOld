/*
Basic level state for the game. Creates a simple platformer.
*/

package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import Reg._gravity;

class LevelState extends FlxState
{
    public var _player:FlxSprite;
    public var _exit:FlxSprite;
    public var _key:FlxSprite;
    public var _blindMask:FlxSprite;
    public var _dashSprite:FlxSprite;
    public var _clubSprite:FlxSprite;
    public var _goldNugget:FlxSprite;
    public var _levelText:FlxText;
    public var _goldNuggetsText:FlxText;
    public var _platforms:FlxSpriteGroup;
    public var _spikes:FlxSpriteGroup;
    public var _vines:FlxSpriteGroup;
    public var _enemies:FlxSpriteGroup;
    public var _water:FlxSpriteGroup;
    public var _doors:FlxSpriteGroup;
    public var _keyNeeded = false;
    public var _keyGot = false;
    public var _secondJump = false;
    public var _moveSpeed:Float = 80;
    public var _sightRadius = 160;
    public var _jumpVelocity = -300;
    public var _debugModeOn = true;
    public var _fastModeOn = false;
    public var _ghostModeOn = false;
    public var _offsetPoint:FlxPoint = null;
    public static var _blackLine:LineStyle = {color: FlxColor.BLACK, thickness: 2};

	override public function create():Void
	{
        /*
        FlxG.debugger.visible = true;
        FlxG.log.redirectTraces = true;
        FlxG.debugger.setLayout(RIGHT);
        FlxG.debugger.setLayout(MICRO);
        // FlxG.debugger.drawDebug = true;
        */

		super.create();
        Reg.LVL = this;
        _player = new FlxSprite(100, 100);
        _player.makeGraphic(10, 10, FlxColor.GRAY);
        _player.acceleration.y = _gravity;
        // _player.visible = false;

        _blindMask = new FlxSprite();
        _blindMask.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        _blindMask.visible = false;
        _dashSprite = new FlxSprite();
        _dashSprite.makeGraphic(40, Std.int(_player.height), FlxColor.WHITE);
        _dashSprite.visible = false;
        _clubSprite = new FlxSprite();
        _clubSprite.makeGraphic(Std.int(_player.width), Std.int(_player.height), FlxColor.WHITE);
        _clubSprite.visible = false;

        _levelText = new FlxText(0, 0, FlxG.width, "Level (unknown)", 12);
        _goldNuggetsText = new FlxText(0, 0, FlxG.width, "Gold nuggets: (unknown)/(unknown)", 12);
        _goldNuggetsText.alignment = RIGHT;

        // Testing code
        // Reg._abilities[Reg.DOUBLE_JUMP] = true;
        // Reg._sacrifices[Reg.RIGHT_EYE] = true;

        _exit = new FlxSprite(390, 180);
        _exit.makeGraphic(10, 20, FlxColor.YELLOW);

        _platforms = new FlxSpriteGroup();
        _vines = new FlxSpriteGroup();
        _enemies = new FlxSpriteGroup();
        _water = new FlxSpriteGroup();
        _spikes = new FlxSpriteGroup();
        _doors = new FlxSpriteGroup();

        var leftMargin = 40;
        var rightMargin = 140;
        var totalMargins = leftMargin+rightMargin;

        if(_debugModeOn)
        {
            Reg._abilities[Reg.DOUBLE_JUMP] = true;
            Reg._abilities[Reg.SPIKE_BOOTS] = true;
        }

        // Check for abilities
        if(Reg._abilities[Reg.DOUBLE_JUMP])
        {
            _secondJump = true;
        }

        // var placeholderText:FlxText = new FlxText(FlxG.width/2, FlxG.height/2, "Placeholder text");
        // add(placeholderText);
        add(_player);
        add(_exit);
        add(_platforms);
        add(_vines);
        add(_enemies);
        add(_water);
        add(_blindMask);
        add(_levelText);
        add(_goldNuggetsText);
        add(_dashSprite);
        add(_clubSprite);
        add(_spikes);
        initializeCurrentLevel();
        _platforms.add(_doors);
        // initializeTestLevel();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        // #region Debug mode specific checks
        if(_debugModeOn)
        {
            if(FlxG.keys.anyJustPressed([F]))
            {
                if(_fastModeOn)
                {
                    FlxG.timeScale = 1.0;
                    _fastModeOn = false;
                }
                else
                {
                    FlxG.timeScale = 2.0;
                    _fastModeOn = true;
                }
            }
            if(FlxG.keys.anyJustPressed([G]))
            {
                if(_ghostModeOn)
                {
                    _ghostModeOn = false;
                    _player.solid = true;
                }
                else
                {
                    _ghostModeOn = true;
                    _player.solid = false;
                }
            }
            if(FlxG.keys.anyJustPressed([N]))
            {
                nextLevel();
            }
        }
        // #endregion

        FlxG.collide(_player, _platforms);
        if(_player.isTouching(FlxObject.DOWN) && Reg._abilities[Reg.DOUBLE_JUMP])
        {
            _secondJump = true;
        }
        _player.acceleration.y = _gravity;

        if(!_ghostModeOn)
        {
            if(_player.overlaps(_vines))
            {
                _player.acceleration.y = 0;
                if(FlxG.keys.anyPressed([UP, W]))
                {
                    _player.velocity.y = -100;
                }
                else if(FlxG.keys.anyPressed([DOWN, S]))
                {
                    _player.velocity.y = 100;
                }
                else
                {
                    _player.velocity.y = 0;
                }
            }
            else if(FlxG.keys.anyJustPressed([UP, W]))
            {
                if(_player.isTouching(FlxObject.DOWN) || _player.y == FlxG.height-20)
                {
                    _player.velocity.y = _jumpVelocity;
                    // _player.acceleration.y = _gravity;
                }
                else if(_secondJump)
                {
                    _player.velocity.y = -300;
                    _secondJump = false;
                    // _player.acceleration.y = _gravity;
                }
            }
        }
        else
        {
            // Ghost mode movement.
            _player.acceleration.y = 0;
            // #region Up/down movement detection
            if(FlxG.keys.pressed.UP || FlxG.keys.pressed.W)
            {
                _player.velocity.y = -1*_moveSpeed;
            }
            else if(FlxG.keys.pressed.DOWN || FlxG.keys.pressed.S)
            {
                _player.velocity.y = _moveSpeed;
            }
            else
            {
                _player.velocity.y = 0;
            }
            // #endregion
        }
        // #region Left/right movement detection
        if(FlxG.keys.pressed.LEFT || FlxG.keys.pressed.A)
        {
            _player.velocity.x = -1*_moveSpeed;
        }
        else if(FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.D)
        {
            _player.velocity.x = _moveSpeed;
        }
        else
        {
            _player.velocity.x = 0;
        }
        // #endregion

        if(FlxG.keys.anyPressed([C, SPACE, ENTER]))
        {
            // Use club.
        }
        if(FlxG.keys.anyPressed([Q, SLASH]))
        {
            // Use dash.
        }

        if(_blindMask.visible)
        {
            FlxSpriteUtil.fill(_blindMask, FlxColor.BLACK);
            FlxSpriteUtil.drawCircle(_blindMask, _player.x, _player.y, _sightRadius, FlxColor.WHITE, _blackLine);
            _blindMask.replaceColor(FlxColor.WHITE, FlxColor.TRANSPARENT);
        }

        if(_key != null)
        {
            if(_player.overlaps(_key))
            {
                _keyGot = true;
                _doors.kill();
                _key.kill();
            }
        }

        if(_goldNugget != null)
        {
            if(_player.overlaps(_goldNugget) && _goldNugget.exists)
            {
                _goldNugget.kill();
                Reg._goldNuggetsCollected++;
                _goldNuggetsText.text = "Gold nuggets "+Reg._goldNuggetsCollected+"/"+Reg._goldNuggetsTotal;
            }
        }

        FlxG.collide(_player, _spikes, onSpikeOverlap);
        if(_player.overlaps(_exit))
        {
            nextLevel();
        }
        else if(_player.overlaps(_enemies) || _player.y>FlxG.height)
        {
            FlxG.switchState(new GameOverState());
        }
	}
    
    /*
    Places the given enemy on the given platform. Places the enemy at the halfway mark if offset<0,
    otherwise places it the given distance from the left-hand side.
    */
    public function spawnOnPlatform(spawnEnemy:Enemy, spawnPlatform:FlxSprite, ?offset=-1):Void
    {
        spawnEnemy._platformOn = spawnPlatform;
        if(offset < 0)
        {
            spawnEnemy.setPosition(spawnPlatform.x+spawnPlatform.width/2, spawnPlatform.y-Enemy._baseHeight);
        }
        else
        {
            spawnEnemy.setPosition(spawnPlatform.x+offset, spawnPlatform.y-Enemy._baseHeight);
        }
        _enemies.add(spawnEnemy);
        // return new Enemy();
    }

    public function spawnPlayerOnPlatform(spawnPlatform:FlxSprite, ?offset=-1):Void
    {
        if(offset < 0)
        {
            _player.setPosition(spawnPlatform.x+spawnPlatform.width/2, spawnPlatform.y-_player.height);
        }
        else
        {
            _player.setPosition(spawnPlatform.x+offset, spawnPlatform.y-_player.height);
        }
    }

    public function spawnExitOnPlatform(spawnPlatform:FlxSprite, ?offset=-1):Void
    {
        if(offset < 0)
        {
            _exit.setPosition(spawnPlatform.x+spawnPlatform.width/2, spawnPlatform.y-_exit.height);
        }
        else
        {
            _exit.setPosition(spawnPlatform.x+offset, spawnPlatform.y-_exit.height);
        }
    }

    public function findPlatformUnder(entityX, entityY):FlxSprite
    {
        var possiblePlatforms:Array<FlxSprite> = new Array();
        var returnPlatform:FlxSprite;
        for(checkPlatform in _platforms)
        {
            if(checkPlatform.x <= entityX && checkPlatform.x+checkPlatform.width >= entityX
            && checkPlatform.y > entityY)
            {
                possiblePlatforms.push(checkPlatform);
            }
        }
        if(possiblePlatforms.length == 0)
        {
            return null;
        }
        else
        {
            returnPlatform = possiblePlatforms[0];
            for(checkPlatform in possiblePlatforms)
            {
                if(checkPlatform.y < returnPlatform.y)
                {
                    returnPlatform = checkPlatform;
                }
            }
        }
        return returnPlatform;
    }

    public function createPlatformColumn(startX, startY, numPlatforms:Int, heightDiff, offset=0, 
    platformsWidth=100, startOnLeft:Bool=true)
    {
        for(i in 0...numPlatforms)
        {
            if(startOnLeft)
            {
                _platforms.add(new Platform(startX+offset*i%2, startY-heightDiff*i, platformsWidth));
            }
            else
            {
                _platforms.add(new Platform(startX+offset*(i+1)%2, startY-heightDiff*i, platformsWidth));
            }
        }
    }

    public function addPlatformByOffsetLast(offsetX, offsetY, platWidth=100)
    {
        var lastPlatformPosition:FlxPoint;
        if(_offsetPoint == null)
        {
            lastPlatformPosition = _platforms.members[_platforms.length-1].getPosition();
        }
        else
        {
            lastPlatformPosition = _offsetPoint;
        }
        _platforms.add(new Platform(lastPlatformPosition.x+offsetX, lastPlatformPosition.y+offsetY, platWidth));
        _offsetPoint = null;
    }

    public function nextLevel():Void
    {
        if(Reg._currentLevel == 1)
        {
            Achievements.unlockAchievementByName("Starting to Cave");
        }
        if(_spikes.members.length > 0)
        {
            Achievements.unlockAchievementByName("Master the Spikes");
        }

        if(Reg._currentLevel<Reg._maxLevel)
        {
            Reg._currentLevel++;
            FlxG.switchState(new LevelState());
        }
        else
        {
            FlxG.switchState(new VictoryState());
        }
    }

    public function onSpikeOverlap(obj1:FlxSprite, obj2:FlxSprite)
    {
        if(Reg._abilities[Reg.SPIKE_BOOTS])
        {
            FlxG.collide(_player, _spikes);
            // Add code to make spike boots deplete.
        }
        else
        {
            FlxG.switchState(new GameOverState());
        }
    }

    public function setOffsetPoint(offsetX, offsetY)
    {
        _offsetPoint = FlxPoint.get(offsetX, offsetY);
    }

    /*
    Gravity: 600
    Jump velocity: 300
    Move speed: 80

    Max jump height: ~70
    Max horizontal gap: ~90

    Window width 640
    Window height 480
    Lowest placement with GUI: 430 

    Max platforms in column (at height difference 60): 7

    Working gap distances (width, height):
    60, 0 (fairly easy)
    20, 60 (moderate-easy)
    80, 0 (difficult)
    85, 0 (difficult)
    90, 0 (near impossible)
    60, 50 (moderate)
    65, 50 (moderate-difficult)
    75, 10 (difficult)
    90, -10 (very difficult)
    85, -10 (difficult)
    40, 60 (moderate)
    50, 60 (moderate)
    55, 60 (moderate-difficult)
    */

    public function initializeCurrentLevel():Void
    {
        _levelText.text = "Level "+Reg._currentLevel;
        _goldNuggetsText.text = "Gold nuggets "+Reg._goldNuggetsCollected+"/"+Reg._goldNuggetsTotal;
        switch(Reg._currentLevel)
        {
            case 1:
                // initializeLevelNine();
                initializeLevelOne();
                // initializeTestLevel();
            case 2:
                initializeLevelTwo();
            case 3:
                initializeLevelThree();
            case 4:
                initializeLevelFour();
            case 5:
                initializeLevelFive();
            case 6:
                initializeLevelSix();
            case 7:
                initializeLevelSeven();
            case 8:
                initializeLevelEight();
            case 9:
                initializeLevelNine();
            case 10:
                initializeLevelTen();
            case 11:
                initializeLevelEleven();
            case 12:
                initializeLevelTwelve();
            case 13:
                initializeLevelThirteen();
            default:
                initializeTestLevel();
                // initializeLevelSeven();
        }
    }

    public function initializeTestLevel()
    {
        _platforms.add(new Platform(20, 430));
        spawnPlayerOnPlatform(_platforms.members[0]);
        /*
        var currentPlatform:FlxSprite = new Platform(50, 200);
        _platforms.add(currentPlatform);
        currentPlatform = new Platform(350, 200);
        _platforms.add(currentPlatform);
        currentPlatform = new Platform(200, 250);
        _platforms.add(currentPlatform);
        currentPlatform = new Platform(150, 350);
        _platforms.add(currentPlatform);

        var currentVine = new FlxSprite(220, 250);
        currentVine.makeGraphic(10, 100, FlxColor.GREEN);
        _vines.add(currentVine);

        var currentEnemy = new Enemy(280, 250-Enemy._baseHeight, Enemy._baseWidth, Enemy._baseHeight, _platforms.members[2]);
        _enemies.add(currentEnemy);
        currentEnemy = new EnemySeeker(70, 200-Enemy._baseHeight, Enemy._baseWidth, Enemy._baseHeight, _platforms.members[0]);
        _enemies.add(currentEnemy);
        currentEnemy = new EnemyJumper(90, 200-Enemy._baseHeight, Enemy._baseWidth, Enemy._baseHeight, _platforms.members[0]);
        _enemies.add(currentEnemy);

        _player.setPosition(160, 340);
        */
    }

    public function initializeLevelOne()
    {
        var currentPlatform:FlxSprite = new FlxSprite(50, 200);
        currentPlatform.makeGraphic(100, 10, FlxColor.WHITE);
        currentPlatform.immovable = true;
        _platforms.add(currentPlatform);
        currentPlatform = new FlxSprite(200, 250);
        currentPlatform.makeGraphic(100, 10, FlxColor.WHITE);
        currentPlatform.immovable = true;
        _platforms.add(currentPlatform);
        currentPlatform = new FlxSprite(350, 200);
        currentPlatform.makeGraphic(100, 10, FlxColor.WHITE);
        currentPlatform.immovable = true;
        _platforms.add(currentPlatform);
    }

    public function initializeLevelTwo()
    {
        var currentPlatform:FlxSprite = new Platform(150, 200, 400);
        _platforms.add(currentPlatform);
        currentPlatform = new Platform(50, 250);
        _platforms.add(currentPlatform);

        var currentEnemy = new Enemy();
        for(i in 0...6)
        {
            currentEnemy = new Enemy(160+45*i, 200-Enemy._baseHeight, Enemy._baseWidth, Enemy._baseHeight, _platforms.members[0]);
            _enemies.add(currentEnemy);
        }

        _player.setPosition(100, 240);
        _exit.setPosition(500, 180);
    }

    public function initializeLevelThree()
    {
        var currentPlatform:FlxSprite;
        for(i in 0...6)
        {
            currentPlatform = new Platform(50+i*100, 300, 50);
            _platforms.add(currentPlatform);
        }

        // var currentEnemy = new Enemy();

        _player.setPosition(60, 290);
        _exit.setPosition(580, 280);
    }

    public function initializeLevelFour()
    {
        var currentPlatform:FlxSprite;
        var enemyPositions:Array<FlxPoint> = new Array();
        for(i in 0...6)
        {
            currentPlatform = new Platform(20+i*90, 300-50*i%2, 70);
            _platforms.add(currentPlatform);
            enemyPositions.push(new FlxPoint(60+i*90, 300-50*i%2-Enemy._baseHeight) );
        }

        var currentEnemy = new Enemy();
        for(i in [1, 2, 5])
        {
            currentEnemy = new Enemy(enemyPositions[i].x, enemyPositions[i].y, Enemy._baseWidth, Enemy._baseHeight, _platforms.members[i]);
            _enemies.add(currentEnemy);
        }
        currentEnemy = new EnemyJumper(enemyPositions[3].x, enemyPositions[3].y, Enemy._baseWidth, Enemy._baseHeight, _platforms.members[3]);
        _enemies.add(currentEnemy);
        currentEnemy = new EnemySeeker(enemyPositions[4].x, enemyPositions[4].y, Enemy._baseWidth, Enemy._baseHeight, _platforms.members[4]);
        _enemies.add(currentEnemy);

        _player.setPosition(60, 290);
        _exit.setPosition(490, 230);
    }

    public function initializeLevelFive()
    {
        var currentPlatform:FlxSprite;
        currentPlatform = new Platform(50, 400, 150);
        _platforms.add(currentPlatform);
        currentPlatform = new Platform(280, 400);
        _platforms.add(currentPlatform);
        currentPlatform = new Platform(390, 340);
        _platforms.add(currentPlatform);
        currentPlatform = new Platform(280, 280);
        _platforms.add(currentPlatform);
        currentPlatform = new Platform(440, 240);
        _platforms.add(currentPlatform);
        currentPlatform = new Platform(80, 190, 300);
        _platforms.add(currentPlatform);

        var currentEnemy:Enemy;
        for(i in 1...5)
        {
            currentEnemy = new Enemy();
            spawnOnPlatform(currentEnemy, _platforms.members[i]);
        }
        currentEnemy = new Enemy();
        spawnOnPlatform(currentEnemy, _platforms.members[5], 200);
        currentEnemy = new Enemy();
        spawnOnPlatform(currentEnemy, _platforms.members[5], 250);

        var currentVine = new FlxSprite(150, 190);
        currentVine.makeGraphic(10, 210, FlxColor.GREEN);
        _vines.add(currentVine);

        _player.setPosition(60, 390);
        _exit.setPosition(350, 170);
    }

    public function initializeLevelSix()
    {
        var currentPlatform:FlxSprite;
        currentPlatform = new Platform(50, 400);
        _platforms.add(currentPlatform);
        currentPlatform = new Platform(150, 270);
        _platforms.add(currentPlatform);
        currentPlatform = new Platform(230, 400, 120);
        _platforms.add(currentPlatform);
        currentPlatform = new Platform(400, 380);
        _platforms.add(currentPlatform);
        currentPlatform = new Platform(280, 320);
        _platforms.add(currentPlatform);
        currentPlatform = new Platform(270, 210);
        _platforms.add(currentPlatform);

        var currentEnemy:Enemy;
        var levelEnemies:Array<Enemy> = [new Enemy(), new Enemy(), new EnemyJumper(), new EnemyJumper()];
        for(i in 2...6)
        {
            currentEnemy = new Enemy();
            spawnOnPlatform(levelEnemies[i-2], _platforms.members[i], (i*10)%30);
        }

        _player.setPosition(60, 390);
        _exit.setPosition(300, 190);
    }

    public function initializeLevelSeven()
    {
        var margin:Float = 60;
        var currentPlatform:FlxSprite;
        currentPlatform = new Platform(margin, 400, Std.int(640-margin*2) ); // Start platform
        _platforms.add(currentPlatform);
        currentPlatform = new Platform(120, 150, 80); // Exit platform
        _platforms.add(currentPlatform);

        // Left column
        currentPlatform = new Platform(20, 330, 80);
        _platforms.add(currentPlatform);
        currentPlatform = new Platform(120, 270, 80);
        _platforms.add(currentPlatform);
        currentPlatform = new Platform(20, 210, 80);
        _platforms.add(currentPlatform);

        currentPlatform = new Platform(Std.int(640-100), 330, 80);
        _platforms.add(currentPlatform);
        currentPlatform = new Platform(520, 110, 80);
        _platforms.add(currentPlatform);
        currentPlatform = new Platform(320, 130, 150); // Long enemy platform
        _platforms.add(currentPlatform);
        currentPlatform = new Wall(340, 10, 110, 105);
        _platforms.add(currentPlatform);

        currentPlatform = new Platform(220, 60, 80); // Gold brick platform
        _platforms.add(currentPlatform);
        _goldNugget = FancyDraw.getGoldBrick();
        _goldNugget.setPosition(260, 50);
        add(_goldNugget);

        var currentVine = new FlxSprite(560, 110);
        currentVine.makeGraphic(10, 220, FlxColor.GREEN);
        _vines.add(currentVine);

        var currentEnemy:Enemy;
        var levelEnemies:Array<Enemy> = [new Enemy(), new Enemy(), new Enemy()];
        var spawnPlatforms:Array<Int> = [3, 6, 7];
        for(i in 0...3)
        {
            currentEnemy = new Enemy();
            spawnOnPlatform(levelEnemies[i], _platforms.members[spawnPlatforms[i]], (i*10)%30);
        }

        spawnPlayerOnPlatform(_platforms.members[0]);
        spawnExitOnPlatform(_platforms.members[1]);
    }

    public function initializeLevelEight()
    {
        var margin:Float = 60;
        var currentPlatform:FlxSprite;
        currentPlatform = new Platform(margin, 400);
        _platforms.add(currentPlatform);
        currentPlatform = new Platform(300, 250);
        _platforms.add(currentPlatform);

        for(i in 1...6)
        {
            currentPlatform = new Platform(margin+90*i%2, 400-60*i, 70);
            _platforms.add(currentPlatform);
            // enemyPositions.push(new FlxPoint(60+i*90, 300-50*i%2-Enemy._baseHeight) );
        }
        currentPlatform = new Platform(280, 100, 70);
        _platforms.add(currentPlatform);
        currentPlatform = new Platform(410, 100, 140);
        _platforms.add(currentPlatform);
        // Ends at 550, 70

        _platforms.add(new Platform(550, 420, 50));
        addPlatformByOffsetLast(-110, 0, 50);
        addPlatformByOffsetLast(-70, -60, 50);
        addPlatformByOffsetLast(70, -60, 50);
        // Top left at 330, 420

        _spikes.add(new Spike(220, 150, 200));

        var currentVine = new FlxSprite(560, 130);
        currentVine.makeGraphic(10, 200, FlxColor.GREEN);
        // _vines.add(currentVine);

        var currentEnemy:Enemy;
        var levelEnemies:Array<Enemy> = [new Enemy(), new Enemy(), new Enemy()];
        var spawnPlatforms:Array<Int> = [2];
        for(i in 0...spawnPlatforms.length)
        {
            currentEnemy = new Enemy();
            spawnOnPlatform(levelEnemies[i], _platforms.members[spawnPlatforms[i]], (i*10)%30);
        }

        spawnPlayerOnPlatform(_platforms.members[0]);
        spawnExitOnPlatform(_platforms.members[1]);
    }

    public function initializeLevelNine()
    {
        var margin:Float = 20;
        _platforms.add(new Platform(margin, 340)); // Start platform

        _platforms.add(new Platform(340, 220, 60)); // Exit platform

        _spikes.add(new Spike(170, 170, 360));

        _platforms.add(new Platform(margin+120, 280, 50));
        addPlatformByOffsetLast(-70, -60, 50);
        addPlatformByOffsetLast(70, -60, 50);
        addPlatformByOffsetLast(135, 0, 20);
        addPlatformByOffsetLast(105, 0, 20);
        addPlatformByOffsetLast(105, 0, 20);
        // End point (top right): 505, 160

        // Gold brick path
        addPlatformByOffsetLast(90, -40, 20);
        addPlatformByOffsetLast(-110, -40, 40);
        addPlatformByOffsetLast(-105, 0, 15);
        addPlatformByOffsetLast(-105, 0, 15);
        addPlatformByOffsetLast(-105, 0, 15);
        addPlatformByOffsetLast(-130, 0, 40);
        // End point (top left): 20, 80
        _goldNugget = FancyDraw.getGoldBrick();
        _goldNugget.setPosition(35, 70);
        add(_goldNugget);

        _platforms.add(new Platform(570, 420, 50));
        addPlatformByOffsetLast(-115, -50, 50);
        addPlatformByOffsetLast(-115, -50, 50);
        addPlatformByOffsetLast(115, -50, 50);

        spawnPlayerOnPlatform(_platforms.members[0]);
        spawnExitOnPlatform(_platforms.members[1]);
    }

    public function initializeLevelTen()
    {
        var margin:Float = 20;
        _platforms.add(new Platform(480, 100)); // Start platform

        _platforms.add(new Platform(510, 370, 80)); // Exit platform

        _platforms.add(new Platform(355, 90, 50));
        addPlatformByOffsetLast(-135, 10, 50);
        addPlatformByOffsetLast(-125, -10, 50);

        _platforms.add(new Platform(20, 210, 70));
        addPlatformByOffsetLast(155, 0, 50);
        addPlatformByOffsetLast(130, 0, 20);
        addPlatformByOffsetLast(100, 0, 20);
        addPlatformByOffsetLast(95, -10, 30);
        addPlatformByOffsetLast(85, -60, 30);

        _platforms.add(new Platform(560, 320, 70));
        _platforms.add(new Platform(80, 320, 400));
        _platforms.add(new Platform(380, 240, 80));
        addPlatformByOffsetLast(-200, 0);
        addPlatformByOffsetLast(-150, 0);
        _platforms.add(new Platform(20, 430, 80));
        addPlatformByOffsetLast(160, 0, 70);
        addPlatformByOffsetLast(150, 0, 70);
        addPlatformByOffsetLast(150, 0, 70);

        var currentVine = new FlxSprite(440, 240);
        currentVine.makeGraphic(10, 85, FlxColor.GREEN);
        _vines.add(currentVine);
        currentVine = new FlxSprite(245, 240);
        currentVine.makeGraphic(10, 80, FlxColor.GREEN);
        _vines.add(currentVine);
        currentVine = new FlxSprite(95, 240);
        currentVine.makeGraphic(10, 80, FlxColor.GREEN);
        _vines.add(currentVine);

        _spikes.add(new Spike(100, 110, 540));
        _spikes.add(new Spike(0, 220, 540));
        _spikes.add(new Spike(100, 330, 540));

        spawnPlayerOnPlatform(_platforms.members[0]);
        spawnExitOnPlatform(_platforms.members[1]);
    }

    public function initializeLevelEleven()
    {
        // Elevator or stairs.
        var margin:Float = 20;
        _platforms.add(new Platform(320, 400, 70)); // Start platform

        _platforms.add(new Platform(320, 60, 70)); // Exit platform

        _platforms.add(new Platform(450, 400, 170));
        addPlatformByOffsetLast(0, -120, 170);
        addPlatformByOffsetLast(0, -120, 170);
        addPlatformByOffsetLast(0, -100, 170);

        _platforms.add(new Platform(190, 400, 50));
        addPlatformByOffsetLast(-105, -60, 50);
        addPlatformByOffsetLast(105, -60, 50);
        addPlatformByOffsetLast(-80, -60, 25);
        addPlatformByOffsetLast(-80, -60, 25);
        addPlatformByOffsetLast(80, -60, 25);
        addPlatformByOffsetLast(100, -10, 40);

        // _platforms.add(new Platform(355, 90, 50));
        // addPlatformByOffsetLast(-135, 10, 50);
        // addPlatformByOffsetLast(-125, -10, 50);

        var currentVine = new FlxSprite(600, 280);
        currentVine.makeGraphic(10, 120, FlxColor.GREEN);
        _vines.add(currentVine);
        currentVine = new FlxSprite(460, 160);
        currentVine.makeGraphic(10, 120, FlxColor.GREEN);
        _vines.add(currentVine);
        currentVine = new FlxSprite(600, 60);
        currentVine.makeGraphic(10, 100, FlxColor.GREEN);
        _vines.add(currentVine);

        // _spikes.add(new Spike(100, 110, 540));

        spawnPlayerOnPlatform(_platforms.members[0]);
        spawnExitOnPlatform(_platforms.members[1]);
    }

    public function initializeLevelTwelve()
    {
        var margin:Float = 20;
        _platforms.add(new Platform(20, 400, 70)); // Start platform

        _platforms.add(new Platform(520, 60, 70)); // Exit platform

        setOffsetPoint(20, 400);
        addPlatformByOffsetLast(90, -60, 70);
        addPlatformByOffsetLast(-90, -60, 70);
        addPlatformByOffsetLast(90, -60, 70);
        addPlatformByOffsetLast(-90, -60, 70);
        addPlatformByOffsetLast(90, -60, 70); // At 110, 100
        _platforms.add(new Wall(200, 100, 5, 380));
        _platforms.add(new Wall(400, 0, 5, 380));

        _platforms.add(new Platform(200, 120, 110));
        addPlatformByOffsetLast(95, 70, 105);
        addPlatformByOffsetLast(-95, 70, 105);
        addPlatformByOffsetLast(95, 70, 105);
        addPlatformByOffsetLast(-95, 70, 105); // At 200, 400

        _platforms.add(new Platform(300, 420, 180));
        addPlatformByOffsetLast(245, -50, 60);
        addPlatformByOffsetLast(-125, -50, 60);
        addPlatformByOffsetLast(125, -50, 60);
        addPlatformByOffsetLast(-125, -50, 60);
        addPlatformByOffsetLast(125, -50, 60);
        addPlatformByOffsetLast(-125, -50, 60);

        // var currentVine = new FlxSprite(600, 280);
        // currentVine.makeGraphic(10, 120, FlxColor.GREEN);
        // _vines.add(currentVine);

        _spikes.add(new Spike(200, 100, 50));

        spawnPlayerOnPlatform(_platforms.members[0]);
        spawnExitOnPlatform(_platforms.members[1]);
    }

    public function initializeLevelThirteen()
    {
        /*
        Space on left: 200
        Space on top: 110
        Space left (vertical): 230
        Space left (horizontal): 540
        Space on right: 200
        Space left (horizontal): 340
        Space on bottom: 110
        Space left (vertical): 120
        Space on left 2: 80
        Space left (horizontal): 260
        */

        var margin:Float = 20;
        _platforms.add(new Platform(20, 400, 60)); // Start platform

        _platforms.add(new Platform(320, 240, 60)); // Exit platform

        _key = FancyDraw.getKey();
        _key.setPosition(610, 410);
        add(_key);
        _platforms.add(new Platform(540, 430));
        spawnOnPlatform(new Enemy(), _platforms.members[_platforms.members.length - 1]);

        var currentDoor = new Wall(590, 0, 5, 50);
        currentDoor.color = FlxColor.BROWN;
        _doors.add(currentDoor);
        _platforms.add(new Platform(580, 50, 60));
        _goldNugget = FancyDraw.getGoldBrick();
        _goldNugget.setPosition(620, 40);
        add(_goldNugget);

        _platforms.add(new Platform(600, 360, 40));

        _platforms.add(new Wall(200, 110, 5, 370));
        // _platforms.add(new Platform(200, 110, 240));
        _spikes.add(new Spike(200, 110, 240));
        _platforms.add(new Wall(440, 110, 5, 200));
        // _platforms.add(new Wall(440, 110, 5, 170));
        _platforms.add(new Platform(260, 280, 180));
        spawnOnPlatform(new Enemy(), _platforms.members[_platforms.members.length - 1], 10);
        spawnOnPlatform(new Enemy(), _platforms.members[_platforms.members.length - 1], 60);
        spawnOnPlatform(new Enemy(), _platforms.members[_platforms.members.length - 1], 110);

        // Left column
        setOffsetPoint(20, 400);
        addPlatformByOffsetLast(90, -60, 70);
        addPlatformByOffsetLast(-90, -60, 70);
        addPlatformByOffsetLast(90, -60, 70);
        addPlatformByOffsetLast(-90, -60, 70);
        addPlatformByOffsetLast(90, -60, 120); // At 110, 100
        spawnOnPlatform(new Enemy(), _platforms.members[_platforms.members.length - 1]);

/*
*/
        // Top row
        // _platforms.add(new Platform(20, 100, 70));
        setOffsetPoint(20, 100);
        // addPlatformByOffsetLast(155, 0, 50);
        setOffsetPoint(175, 100);
        addPlatformByOffsetLast(130, 0, 20);
        addPlatformByOffsetLast(100, 0, 20);
        addPlatformByOffsetLast(95, -10, 30);
        // Ends at top-left: 500, 90

        // Right column
        setOffsetPoint(440, 110);
        addPlatformByOffsetLast(0, 40, 120);
        addPlatformByOffsetLast(80, 40, 120);
        addPlatformByOffsetLast(-80, 40, 120);
        addPlatformByOffsetLast(80, 40, 120);
        addPlatformByOffsetLast(-80, 40, 120);
        for(i in 0...5)
        {
            spawnOnPlatform(new Enemy(), _platforms.members[_platforms.members.length - 1 - i], i*10);
        }
        // setOffsetPoint(440, 310);
        // Ends at top-left 440, 310

        _platforms.add(new Platform(550, 400, 50));
        addPlatformByOffsetLast(-110, 0, 50);
        addPlatformByOffsetLast(-110, 0, 50);
        addPlatformByOffsetLast(-110, 0, 50);
        for(i in 0...3)
        {
            _spikes.add(new Spike(220+60+110*i, 360, 30));
        }

        _platforms.add(new Platform(200, 340, 30));

        // _platforms.add(new Platform(200, 120, 110));

        // var currentVine = new FlxSprite(600, 280);
        // currentVine.makeGraphic(10, 120, FlxColor.GREEN);
        // _vines.add(currentVine);

        // _spikes.add(new Spike(200, 100, 50));

        spawnPlayerOnPlatform(_platforms.members[0]);
        spawnExitOnPlatform(_platforms.members[1]);
    }

    public function initializeLevelFourteen()
    {
    }

    public function initializeLevelFifteen()
    {
    }

    public function initializeLevelSixteen()
    {
    }

    public function initializeLevelSeventeen()
    {
    }

    public function initializeLevelEighteen()
    {
    }

    public function initializeLevelNineteen()
    {
    }

    public function initializeLevelTwenty()
    {
    }

    static public function getEyeIcon(?iconWidth=20, ?iconHeight=20):FlxSprite
    {
        var returnIcon:FlxSprite = new FlxSprite();
        returnIcon.makeGraphic(iconWidth, iconHeight, FlxColor.WHITE, true);
        FlxSpriteUtil.drawCircle(returnIcon, returnIcon.width/2, returnIcon.height/2, returnIcon.width*2/5, FlxColor.TRANSPARENT,
        _blackLine);
        FlxSpriteUtil.drawCircle(returnIcon, returnIcon.width/2, returnIcon.height/2, returnIcon.width/10, FlxColor.BLACK,
        _blackLine);
        return returnIcon;
    }

    static public function getHandsIcon(?iconWidth=20, ?iconHeight=20):FlxSprite
    {
        /*
        Ellipse formula: x^2/a^2+y^2/b^2=1
        a=width/2, b=height/2
        x^2/a^2=1-y^2/b^2
        x^2=a^2*(1-y^2/b^2)
        x=sqrt(a^2*(1-y^2/b^2))
        */
        var returnIcon:FlxSprite = new FlxSprite();
        returnIcon.makeGraphic(iconWidth, iconHeight, FlxColor.WHITE, true);

        var bodyWidth = returnIcon.width*.4;
        var bodyHeight = returnIcon.height*.8;
        FlxSpriteUtil.drawEllipse(returnIcon, returnIcon.width/2-bodyWidth/2, 0,
        bodyWidth, bodyHeight, FlxColor.TRANSPARENT, _blackLine);

        var shoulderPt = new FlxPoint(returnIcon.width/2-bodyWidth/2, bodyHeight/2);
        var wristPt = new FlxPoint(returnIcon.width*.15, returnIcon.height*.2);
        var fingerPt = new FlxPoint(returnIcon.width*.07, wristPt.y);
        FlxSpriteUtil.drawLine(returnIcon, shoulderPt.x, shoulderPt.y, wristPt.x, wristPt.y, _blackLine);
        FlxSpriteUtil.drawLine(returnIcon, wristPt.x, wristPt.y, fingerPt.x, fingerPt.y, _blackLine);
        FlxSpriteUtil.drawLine(returnIcon, returnIcon.width-shoulderPt.x, shoulderPt.y, returnIcon.width-wristPt.x, wristPt.y, _blackLine);
        FlxSpriteUtil.drawLine(returnIcon, returnIcon.width-wristPt.x, wristPt.y, returnIcon.width-fingerPt.x, fingerPt.y, _blackLine);
        return returnIcon;
    }

    static public function getArmsIcon(?iconWidth=20, ?iconHeight=20):FlxSprite
    {
        var returnIcon:FlxSprite = new FlxSprite();
        returnIcon.makeGraphic(iconWidth, iconHeight, FlxColor.WHITE, true);

        var bodyWidth = returnIcon.width*.4;
        var bodyHeight = returnIcon.height*.8;
        FlxSpriteUtil.drawEllipse(returnIcon, returnIcon.width/2-bodyWidth/2, 0,
        bodyWidth, bodyHeight, FlxColor.TRANSPARENT, _blackLine);

        var shoulderPt = new FlxPoint(returnIcon.width/2-bodyWidth/2, bodyHeight/2);
        var wristPt = new FlxPoint(returnIcon.width*.15, returnIcon.height*.2);
        var fingerPt = new FlxPoint(returnIcon.width*.07, wristPt.y);
        FlxSpriteUtil.drawLine(returnIcon, shoulderPt.x, shoulderPt.y, wristPt.x, wristPt.y, _blackLine);
        FlxSpriteUtil.drawLine(returnIcon, returnIcon.width-shoulderPt.x, shoulderPt.y, returnIcon.width-wristPt.x, wristPt.y, _blackLine);
        return returnIcon;
    }

    static public function getFeetIcon(?iconWidth=20, ?iconHeight=20):FlxSprite
    {
        var returnIcon:FlxSprite = new FlxSprite();
        returnIcon.makeGraphic(iconWidth, iconHeight, FlxColor.WHITE, true);
        var btmPt = new FlxPoint(returnIcon.width*.4, returnIcon.height*.6);
        var ctrlPt = new FlxPoint(returnIcon.width*.17, returnIcon.height*.5);
        var toeXPos = returnIcon.width*.15;
        
        FlxSpriteUtil.drawLine(returnIcon, btmPt.x, 0, btmPt.x, btmPt.y, _blackLine);
        FlxSpriteUtil.drawLine(returnIcon, returnIcon.width-btmPt.x, 0, returnIcon.width-btmPt.x, btmPt.y, _blackLine);
        FlxSpriteUtil.drawCurve(returnIcon, btmPt.x, btmPt.y, ctrlPt.x, ctrlPt.y, toeXPos, btmPt.y, FlxColor.BLACK, _blackLine);
        FlxSpriteUtil.drawCurve(returnIcon, returnIcon.width-btmPt.x, btmPt.y, returnIcon.width-ctrlPt.x, ctrlPt.y, 
        returnIcon.width-toeXPos, btmPt.y, FlxColor.BLACK, _blackLine);
        return returnIcon;
    }

    static public function getLegsIcon(?iconWidth=20, ?iconHeight=20):FlxSprite
    {
        var returnIcon:FlxSprite = new FlxSprite();
        returnIcon.makeGraphic(iconWidth, iconHeight, FlxColor.WHITE, true);
        return returnIcon;
    }

    static public function getHeartIcon(?iconWidth=20, ?iconHeight=20):FlxSprite
    {
        return getHeartIconCurves(iconWidth, iconHeight);
    }

    static public function getHeartIconCurves(?iconWidth=20, ?iconHeight=20):FlxSprite
    {
        var returnIcon:FlxSprite = new FlxSprite();
        returnIcon.makeGraphic(iconWidth, iconHeight, FlxColor.WHITE, true);
        // var ctrlPt = new FlxPoint(returnIcon.width*1/10, returnIcon.height*1/5);
        var ctrlPt = new FlxPoint(0, returnIcon.height*1/5);
        var btmYPos = returnIcon.height*4/5;
        var topYPos = returnIcon.height*.35;

        FlxSpriteUtil.drawCurve(returnIcon, returnIcon.width/2, btmYPos, 
        ctrlPt.x, ctrlPt.y, returnIcon.width/2, topYPos, FlxColor.BLACK, _blackLine);
        FlxSpriteUtil.drawCurve(returnIcon, returnIcon.width/2, btmYPos, 
        returnIcon.width-ctrlPt.x, ctrlPt.y, returnIcon.width/2, topYPos, FlxColor.BLACK, _blackLine);
        return returnIcon;
    }

    static public function getHeartIconCircles(?iconWidth=20, ?iconHeight=20):FlxSprite
    {
        var returnIcon:FlxSprite = new FlxSprite();
        returnIcon.makeGraphic(iconWidth, iconHeight, FlxColor.WHITE, true);
        // var ctrlPt = new FlxPoint(returnIcon.width*1/10, returnIcon.height*1/5);
        var ctrlPt = new FlxPoint(0, returnIcon.height*1/5);
        var circleCtrPt = new FlxPoint(0, returnIcon.height*1/5);
        var btmYPos = returnIcon.height*4/5;
        var circleYPos = returnIcon.height*.35;
        var topYPos = returnIcon.height*.35;

        FlxSpriteUtil.drawCurve(returnIcon, returnIcon.width/2, btmYPos, 
        ctrlPt.x, ctrlPt.y, returnIcon.width/2, topYPos, FlxColor.BLACK, _blackLine);
        FlxSpriteUtil.drawCurve(returnIcon, returnIcon.width/2, btmYPos, 
        returnIcon.width-ctrlPt.x, ctrlPt.y, returnIcon.width/2, topYPos, FlxColor.BLACK, _blackLine);
        return returnIcon;
    }
}
