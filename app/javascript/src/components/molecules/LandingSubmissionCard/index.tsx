import React from 'react';
import Link from 'src/components/atoms/Link';

import AvatarWithTier from 'src/components/atoms/AvatarWithTier';
import styles from './landingSubmission.module.scss';

const {
  mainWrapper,
  titleText,
  descriptionText,
  subWrapper,
  textWrapper,
  statusWrapper,
  commentWrapper,
  count,
  imgWrapper,
} = styles;

export type LandingSubmissionCardProps = {
  title: string;
  description: string;
  comment_count: number;
  tier: number;
  image: string;
  loading: boolean;
  borderColor: string;
  url: string;
};

const LandingSubmissionCard = ({
  title,
  description,
  comment_count,
  tier,
  image,
  loading,
  borderColor,
  url,
}: LandingSubmissionCardProps) => {
  return (
    <>
      <a href={url}>
        <a>
          <div className={mainWrapper}>
            <div className={subWrapper}>
              <div className={textWrapper}>
                <div className={imgWrapper}>
                  <AvatarWithTier tier={tier} image={image} loading={loading} borderColor={borderColor} />
                </div>
                <div>
                  <div className={titleText}>{title}</div>
                  <div className={descriptionText}>{description}</div>
                </div>
              </div>
              <div className={statusWrapper}>
                <div className={commentWrapper}>
                  <i className="las la-comment" style={{ color: '#747474' }}></i>
                  <span className={count}>{comment_count}</span>
                </div>
              </div>
            </div>
          </div>
        </a>
      </a>
    </>
  );
};

export default LandingSubmissionCard;
