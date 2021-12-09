import React from 'react';
import Skeleton from 'react-loading-skeleton';
import Image from 'next/image';

import styles from './avatarWithTier.module.scss';
const { onCardAvatar } = styles;

export type AvatarWithTierProps = {
  id?: number;
  tier: number;
  image: string;
  loading: boolean;
  size?: 'sm' | 'lg' | 'md' | 'ml';
  onCard?: boolean;
  borderColor?: string;
  priority?: boolean;
};

const AvatarWithTier = ({ tier, image, size, loading, onCard, borderColor, priority }: AvatarWithTierProps) => {
  if (onCard) {
    return (
      <>
        {loading ? (
          <div>
            <Skeleton circle={true} width={23} height={23} />
          </div>
        ) : (
          <div className={onCardAvatar} style={{ borderColor: borderColor }}>
            <img
              src={image}
              alt="User avatar"
              placeholder="blur"
              blurDataURL="data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="
              layout="fill"
              objectFit="contain"
              priority={priority}
            width="100%"/>
          </div>
        )}
      </>
    );
  } else {
    return (
      <>
        {loading ? (
          <div>
            <Skeleton circle={true} width={34} height={34} />
          </div>
        ) : (
          <div className={`${styles[`user-rating-${tier}`]} ${styles[size ? `user-rating-${size}` : 'user-rating']}`}>
            {/* <div className={styles.avatar} style={{ position: 'relative' }}> */}
            <img src={image} className={styles.avatar}></img>
            {/* <img
                src={image}
                placeholder="blur"
                blurDataURL="data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="
                layout="fill"
                objectFit="contain"
                alt="User avatar"
              width="100%"/> */}
            {/* </div> */}
          </div>
        )}
      </>
    );
  }
};
export default AvatarWithTier;
