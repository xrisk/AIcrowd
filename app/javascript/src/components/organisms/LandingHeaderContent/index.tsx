import React from 'react';
import { useRouter } from 'next/router';

import useMediaQuery from 'src/hooks/useMediaQuery';
import { sizes } from 'src/constants/screenSizes';

import ButtonDefault from 'src/components/atoms/Button/ButtonDefault';
import AicrowdLogo from 'src/components/atoms/AicrowdLogo';

import styles from './landingChallengeCard.module.scss';
import ActionButton from 'src/components/atoms/Button/ActionButton';
const { main, titleText, descriptionText, heroTitle, buttonWrapper, registerButtonWrapper } = styles;

export type LandingHeaderContentProps = {
  title?: string;
  description: any;
  buttonText: string;
  hero?: boolean;
  descriptionWidth?: string;
  logo?: boolean;
  buttonType?: string;
  isLoggedIn?: boolean;
  url?: string;
};

const LandingHeaderContent = ({
  title,
  description,
  buttonText,
  hero,
  descriptionWidth,
  logo,
  buttonType,
  isLoggedIn,
  url,
}: LandingHeaderContentProps) => {
  const router = useRouter();
  const { wide, xLarge, xSmall, small, medium, large, smallMedium } = sizes;

  const isS = useMediaQuery(small);
  const isXL = useMediaQuery(xLarge);
  const isXS = useMediaQuery(xSmall);
  const isL = useMediaQuery(large);

  const isJoinCommunity = title === 'Welcome to AIcrowd Community' || title === 'Join our Global Community';
  return (
    <>
      <div className={main}>
        {hero && !isXS && (
          <div className={heroTitle}>
            Crowdsourcing AI <br />
            to Solve Real-World Problems
          </div>
        )}
        {/* Show only on small screen */}
        {hero && isXS && (
          <div className={heroTitle}>
            Crowdsourcing AI to <br />
            Solve Real-World Problems
          </div>
        )}
        {!hero && (
          <div>
            {logo && (
              <AicrowdLogo
                type="text"
                size={isS ? 28 : isL ? 34 : isXL ? 40 : 48}
                fontFamily="Inter"
                fontWeight={isL ? 500 : 600}
              />
            )}{' '}
            <span className={titleText} style={{ width: descriptionWidth }}>
              {title}
            </span>
          </div>
        )}
        <div className={descriptionText} style={{ width: descriptionWidth }}>
          {hero && <AicrowdLogo type="text" size={isXL ? 16 : 19} fontFamily="Inter" />} {description}
        </div>
        <div className={buttonWrapper}>
          {/* Show in hero only */}
          {hero && (
            <div style={{ paddingRight: '26px' }}>
              <ButtonDefault
                text="Our Challenges"
                iconClass="arrow-right"
                iconColor="white"
                type="primary"
                paddingTop="8px"
                paddingBottom="8px"
                iconSize="18px"
                fontFamily="Inter"
                handleClick={() => router.push('/challenges')}
              />
            </div>
          )}
          {/* Hide button for hero in small screen */}
          {(hero && isS) || isJoinCommunity ? (
            <></>
          ) : (
            <ButtonDefault
              text={buttonText}
              iconClass="arrow-right"
              iconColor={buttonType === 'primary' ? '#ffffff' : '#F0524D'}
              type={buttonType || 'secondary'}
              paddingTop="8px"
              paddingBottom="8px"
              iconSize="18px"
              fontFamily="Inter"
              handleClick={() => router.push(url || '/')}
            />
          )}
        </div>
        {/* Show only on join our community section */}
        {isJoinCommunity && (
          <div className={registerButtonWrapper}>
            {!isLoggedIn && (
              <>
                <ActionButton type="google" size="large" fontFamily="Inter" />
                <ActionButton type="github" size="large" fontFamily="Inter" />
                <ButtonDefault
                  text="Sign Up With Email"
                  iconClass="envelope"
                  iconColor="#F0524D"
                  type="secondary"
                  iconSize="24px"
                  size="large"
                  iconLeft
                  fontSize="12px"
                  fontWeight="500"
                  fontFamily="Inter"
                  justifyContent="flex-end"
                  handleClick={() => router.push('/register')}
                />
              </>
            )}
            {isLoggedIn && (
              <>
                <ButtonDefault
                  text="Explore Challenges"
                  iconClass="arrow-right"
                  iconColor="#F0524D"
                  type="secondary"
                  iconSize="24px"
                  size="large"
                  fontSize="12px"
                  fontWeight="500"
                  fontFamily="Inter"
                  justifyContent="flex-end"
                  handleClick={() => router.push('/challenges')}
                />
                <ButtonDefault
                  text="Explore Notebooks"
                  iconClass="arrow-right"
                  iconColor="#F0524D"
                  type="secondary"
                  iconSize="24px"
                  size="large"
                  fontSize="12px"
                  fontWeight="500"
                  fontFamily="Inter"
                  justifyContent="flex-end"
                  handleClick={() => router.push('/notebooks')}
                />
                <ButtonDefault
                  text="Explore Discussions"
                  iconClass="arrow-right"
                  iconColor="#F0524D"
                  type="secondary"
                  iconSize="24px"
                  size="large"
                  fontSize="12px"
                  fontWeight="500"
                  fontFamily="Inter"
                  justifyContent="flex-end"
                  handleClick={() => router.push('/discussions')}
                />
              </>
            )}
          </div>
        )}
      </div>
    </>
  );
};

export default LandingHeaderContent;
