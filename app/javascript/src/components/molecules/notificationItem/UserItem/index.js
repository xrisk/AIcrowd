import React from 'react';
import Skeleton from 'react-loading-skeleton';

import AvatarWithTier from 'src/components/atoms/AvatarWithTier';
import styles from './userItem.module.scss';

const UserItem = ({ userNotification, loading }) => {
  const { image, tier, time, userName } = userNotification;

  return (
    <>
      <div className={styles['notification-item-user']}>
        <a className={styles['notification-item-overlay']} href="/"></a>
        <div className={styles['notification-item-content']}>
          <div className={styles['notification-item-image']}>
            <AvatarWithTier image={image} tier={tier} loading={loading} />
          </div>
          <div className={styles['notification-item-text']}>
            <span className={styles['notification-item-description']}>
              {loading ? (
                <Skeleton width={120} />
              ) : (
                <>
                  <strong>{userName}</strong> followed you
                </>
              )}
            </span>
            <span className={styles['notification-item-time']}>
              {loading ? <Skeleton width={79} height={16} /> : time}
            </span>
          </div>
        </div>
      </div>
    </>
  );
};
export default UserItem;
