package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import openfl.display.BitmapData;

/*
Stores all achievement data for the game. Initialized by Reg.
IMPORTANT: When copying, rename the save binding string to avoid overlap.
*/
class Achievements
{
    public static var _achievementsList:Array<AchievementData> = null;
    public static var _achievementsSave:FlxSave = null;

    public static function initializeAchievements()
    {
        _achievementsList = new Array();
        var currentAchievement:AchievementData = new AchievementData();

        currentAchievement = new AchievementData();
        currentAchievement._name = "Starting to Cave";
        currentAchievement._description = "Completed the first level.";
        _achievementsList.push(currentAchievement);

        currentAchievement = new AchievementData();
        currentAchievement._name = "Master the Spikes";
        currentAchievement._description = "Finished a level with spikes in it.";
        currentAchievement._icon = new FlxSprite();
        currentAchievement._icon.loadGraphicFromSprite(FancyDraw.getHeartIcon(40, 40));
        // currentAchievement._iconBitmap = null;
        _achievementsList.push(currentAchievement);

        currentAchievement = new AchievementData();
        currentAchievement._name = "Cave Master";
        currentAchievement._description = "Completed the game.";
        _achievementsList.push(currentAchievement);

        currentAchievement = new AchievementData();
        currentAchievement._name = "Filthy Rich";
        currentAchievement._description = "Collect all 3 gold nuggets.";
        _achievementsList.push(currentAchievement);

        _achievementsSave = new FlxSave();
        _achievementsSave.bind("CharTypeCaveOfAdventureSaves");
        // if(_achievementsSave.data.achievementList != null)
        if(false)
        {
            _achievementsList = _achievementsSave.data.achievementList;
        }
        else
        {
            _achievementsSave.data.achievementList = _achievementsList;
        }
        _achievementsSave.flush();
    }

    public static function getAchievementByName(name:String)
    {
        for(checkAchievement in _achievementsList)
        {
            if(checkAchievement._name == name)
            {
                return checkAchievement;
            }
        }
        return null;
    }

    public static function unlockAchievementByName(name:String)
    {
        if(Achievements.getAchievementByName(name) != null)
        {
            Achievements.getAchievementByName(name)._unlocked = true;
        }
    }
}
