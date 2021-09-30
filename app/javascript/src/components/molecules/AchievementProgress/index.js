import React, { useState, useRef, useEffect } from 'react';

import styles from './achievementProgress.module.scss';
const {
  emptyLine,
  fill,
  dot,
  first,
  bronze,
  silver,
  gold,
  bronzeempty,
  silverempty,
  goldempty,
  targetText,
  innerRadius,
} = styles;

export type AchievementProgressProps =
  | {
      target: { bronze_count: number; silver_count: number; gold_count: number };
      progress: number;
      hideFirst?: boolean;
      hideBronze?: never;
    }
  | {
      target: { bronze_count: number; silver_count: number; gold_count: number };
      progress: number;
      hideFirst?: never;
      hideBronze?: boolean;
    };

const AchievementProgress = ({ target, progress, hideFirst, hideBronze }: AchievementProgressProps) => {
  const [totalProgress, setTotalProgress] = useState(100);
  const [isEmpty, setIsEmpty] = useState({
    bronze: hideFirst ? false : true,
    silver: hideBronze ? false : true,
    gold: true,
  });

  const { bronze_count, silver_count, gold_count } = target;
  const fillRef = useRef(null);

  const allBadgeColor =
    'linear-gradient( 90deg, #dd4944 0%, #d0322d 32.78%,#c4632b 34.9%,#b35a28 66.62%,#a2a3a3 68.75%, #8e8f8f 100% )';
  const hideFirstColor = 'linear-gradient( 90deg,#c4632b 34.9%,#b35a28 50.62%,#a2a3a3 50.75%, #8e8f8f 100% )';
  const hideBronzeColor = 'linear-gradient( 90deg,#a2a3a3 100.75%, #8e8f8f 100% )';

  // Position of dot from start of bar
  const bronzeLeft = hideFirst || hideBronze ? '0%' : null;
  const silverLeft = hideFirst ? '48%' : hideBronze ? '0%' : null;
  const goldLeft = null;

  // fill the bar based on progress completed
  useEffect(() => {
    const barFillPortion = hideFirst ? 50 : hideBronze ? 100 : 33;

    // calculate progress of achievements
    const bronzeProgress = (progress / bronze_count) * 100;
    const silverProgress = (progress / silver_count) * 100;
    const goldProgress = (progress / gold_count) * 100;

    // check if progress 100% or not;
    const bronzeProgressPercent = hideBronze || hideFirst ? 0 : bronzeProgress > 100 ? 100 : bronzeProgress;
    const silverProgressPercent = hideBronze ? 0 : silverProgress > 100 ? 100 : silverProgress;
    const goldProgressPercent = goldProgress > 100 ? 100 : goldProgress;

    // Divide progress into 3 parts
    // calculate individual bar progress;
    const bronzeBarFill = (barFillPortion * bronzeProgressPercent) / 100;
    const silverBarFill = (barFillPortion * silverProgressPercent) / 100;
    const goldBarFill = (barFillPortion * goldProgressPercent) / 100;

    // check if individual bar progress is 100% or not;
    const bronzeBarFillPercent = bronzeBarFill > 100 ? barFillPortion : bronzeBarFill;
    const silverBarFillPercent = silverBarFill > 100 ? barFillPortion : silverBarFill;
    const goldBarFillPercent = goldBarFill > 100 ? barFillPortion : goldBarFill;

    // Fill color in bar based on progress in each achievement
    if (progress > gold_count) {
      // if progress is greater then  gold_count fill progress to 100
      setTotalProgress(100);
      setIsEmpty({ ...isEmpty, bronze: false, silver: false, gold: false });

      /*
    1. First, it checks if the user has earned the bronze badge. If so, it sets the total progress to the bronze bar fill percentage.
    2. If the user has earned the bronze badge, it sets the isEmpty object to false for the bronze badge.
    */
    } else if (!hideFirst && !hideBronze && progress <= bronze_count) {
      setTotalProgress(bronzeBarFillPercent);
      if (progress === bronze_count) {
        setIsEmpty({ ...isEmpty, bronze: false });
      } else {
        setIsEmpty({ ...isEmpty, bronze: true });
      }

      // First check if bronze is not hidden if so, check if progress is
      // less or equal silver if so, fill progress till silver & fill bronze & silver dots
    } else if (!hideBronze && progress > 0 && progress <= silver_count) {
      setTotalProgress(bronzeBarFillPercent + silverBarFillPercent);
      setIsEmpty({ ...isEmpty, bronze: false });
      if (progress === silver_count) {
        setIsEmpty({
          ...isEmpty,
          bronze: false,
          silver: false,
        });
      } else {
        setIsEmpty({
          ...isEmpty,
          bronze: false,
          silver: true,
        });
      }
      // if progress is less then or equal to gold
    } else if (!hideBronze && progress > silver_count && progress <= gold_count) {
      setTotalProgress(bronzeBarFillPercent + silverBarFillPercent + goldBarFillPercent);
      setIsEmpty({ ...isEmpty, bronze: false, silver: false });
      if (progress === gold_count) {
        setIsEmpty({ ...isEmpty, bronze: false, silver: false, gold: false });
      } else {
        setIsEmpty({ ...isEmpty, gold: true });
      }
    } else if (hideBronze) {
      setTotalProgress(goldBarFillPercent);
      if (progress === gold_count) {
        setIsEmpty({ ...isEmpty, gold: false });
      } else {
        setIsEmpty({ ...isEmpty, gold: true });
      }
    }
    fillRef.current.style.width = `${100 - totalProgress}%`;
  }, [target, progress, totalProgress, setTotalProgress, hideFirst]);

  return (
    <div>
      <div>
        <div className={targetText}>
          {progress}/{gold_count}
        </div>
        <div
          className={emptyLine}
          style={{ background: hideFirst ? hideFirstColor : hideBronze ? hideBronzeColor : allBadgeColor }}>
          <div className={fill} ref={fillRef}>
            <span className={innerRadius}></span>
            {!hideFirst && <div className={`${dot} ${first}`}></div>}
            {!hideBronze && (
              <div className={`${dot} ${bronze} ${isEmpty.bronze && bronzeempty}`} style={{ left: bronzeLeft }}></div>
            )}
            <div className={`${dot} ${silver} ${isEmpty.silver && silverempty}`} style={{ left: silverLeft }}></div>
            <div className={`${dot} ${gold} ${isEmpty.gold && goldempty}`} style={{ left: goldLeft }}></div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default AchievementProgress;
