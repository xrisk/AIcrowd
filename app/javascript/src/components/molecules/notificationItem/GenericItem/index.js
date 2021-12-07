import React from 'react';
import Skeleton from 'react-loading-skeleton';

import styles from './genericItem.module.scss';

const GenericItem = ({ genericNotification, loading }) => {
  const { image, text, date } = genericNotification;

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
              {loading ? <Skeleton width={250} /> : <>{text}</>}
            </span>
            <span className={styles['notification-item-time']}>{loading ? <Skeleton width={60} /> : date}</span>
          </div>
        </div>
      </div>
    </>
  );
};
export default GenericItem;
