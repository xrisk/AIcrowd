import React from 'react';

import styles from './landingChallengeCard.module.scss';
import AvatarGroup from 'src/components/molecules/AvatarGroup';
import CircleValue from 'src/components/atoms/CircleValue';
import CardBadge from 'src/components/atoms/CardBadge';
import ChallengeCardStatItem from './ChallengeCardStatItem';
const {
  main,
  titleText,
  prizeText,
  leftImg,
  rightContent,
  descriptionText,
  descriptionBox,
  submissionCountText,
  statsBox,
  hashtagText,
  textWrapper,
  participantsWrapper,
  circleValue,
  cardBadgeWrapper,
  challengeImage,
} = styles;

import { ChallengeCardProps } from 'src/types';

const LandingChallengeCard = ({
  image,
  name,
  description,
  submissionCount,
  organizerImage,
  prizes,
  hashtags,
  users,
  color,
  badgeColor,
  challengeEndDate,
  cardBadge,
  loading,
}: ChallengeCardProps) => {
  return (
    <>
      <div className={main}>
        <div className={cardBadgeWrapper}>
          <CardBadge badgeColor={badgeColor} challengeEndDate={challengeEndDate} cardBadge={cardBadge} />
        </div>
        <div className={leftImg} style={{ background: color }}>
          <img src={image} className={challengeImage}></img>
        </div>
        <div className={rightContent}>
          <div>
            <div className={textWrapper}>
              <div style={{ display: 'flex' }}>
                {hashtags.map((tag, i) => {
                  return (
                    <div className={hashtagText} key={i}>
                      #{tag} {i + 1 < hashtags.length && '•'}&nbsp;
                    </div>
                  );
                })}
              </div>
              <div className={titleText}>{name}</div>
              <div className={descriptionBox}>
                <div className={descriptionText}>{description}</div>
              </div>
            </div>

            {/* Prize stat */}
            <ChallengeCardStatItem name="Prizes">
              <div style={{ display: 'flex' }}>
                {prizes.map((prize, i) => {
                  return (
                    <div className={prizeText} key={i}>
                      {prize} {i + 1 < prizes.length && '•'}&nbsp;
                    </div>
                  );
                })}
              </div>
            </ChallengeCardStatItem>
          </div>

          <div className={statsBox}>
            {/* Participant stat */}
            <ChallengeCardStatItem name="Participants">
              <div className={participantsWrapper}>
                <AvatarGroup users={users} size="sm" onCard={true} loading={loading} />
                <div className={circleValue}>
                  <CircleValue value={12} size="sm" onCard={true} />
                </div>
              </div>
            </ChallengeCardStatItem>

            {/* Submission stat */}
            <ChallengeCardStatItem name="Submissions">
              <div className={submissionCountText}>{submissionCount}</div>
            </ChallengeCardStatItem>

            {/* Organizers */}
            <ChallengeCardStatItem name="Organizers">
              <img src={organizerImage}></img>
            </ChallengeCardStatItem>
          </div>
        </div>
      </div>
    </>
  );
};

export default LandingChallengeCard;
