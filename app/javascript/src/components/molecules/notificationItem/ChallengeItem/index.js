import React from 'react';
import Skeleton from 'react-loading-skeleton';

import styles from './challengeItem.module.scss';

const ChallengeItem = ({ challengeNotification, loading }) => {
  const { image, previousPosition, currentPosition, challengeTitle, date } = challengeNotification;

  return (
    <>
      <div className={styles['notification-item-challenge']}>
        <a className={styles['notification-item-overlay']} href="/"></a>
        <div className={styles['notification-item-content']}>
          <div className={styles['notification-item-image']}>
            {loading ? (
              <Skeleton width={36} circle={true} height={36} />
            ) : (
              <img className={styles['avatar']} src={image} alt="User avatar"></img>
            )}
          </div>
          <div className={styles['notification-item-text']}>
            <span className={styles['notification-item-description']}>
              {loading ? (
                <Skeleton width={250} />
              ) : (
                <>
                  You have moved from {previousPosition} to {currentPosition} place n the{' '}
                  <strong>{challengeTitle}</strong> leaderboard
                </>
              )}
            </span>
            <span className={styles['notification-item-time']}>{loading ? <Skeleton width={60} /> : date}</span>
          </div>
        </div>
      </div>
    </>
  );
};
export default ChallengeItem;
