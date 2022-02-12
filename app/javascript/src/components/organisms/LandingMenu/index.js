import React from 'react';
import Link from 'next/link';

import styles from './landingMenu.module.scss';
import SocialButtons from 'src/components/atoms/Button/SocialButtons';
const { main, menuWrapper, loginText, socialIconWrapper } = styles;

const LandingMenu = ({ profileMenuItem, isLoggedIn }) => (
  <>
    <div className={main}>
      <div className={menuWrapper}>
        <a href="/landing_page/host">
          <a>Host a Challenge</a>
        </a>
        <a href="/challenges">
          <a>Challenges</a>
        </a>
        <a href="/showcase">
          <a>Showcase</a>
        </a>
        <a href="/research">
          <a>Research</a>
        </a>
        <a href="https://discourse.aicrowd.com/">
          <a>Forum</a>
        </a>
        <a href="https://blog.aicrowd.com/">
          <a>Blog</a>
        </a>
        {!isLoggedIn && (
          <>
            <div className={loginText}>
              <a href="/participants/sign_in">
                <a>Log In</a>
              </a>
            </div>
            <a href="/participants/sign_up">
              <a>Signup</a>
            </a>
          </>
        )}

        {isLoggedIn &&
          profileMenuItem.map(item => {
            const { name, link } = item;
            return (
              <div className={name === 'Profile' ? loginText : ''} key={name}>
                <a href={link}>
                  <a>{name}</a>
                </a>
              </div>
            );
          })}

        <div className={socialIconWrapper}>
          <SocialButtons socialType="facebook" iconType="outline" link="https://www.facebook.com/AIcrowdHQ/" />
          <SocialButtons socialType="twitter" iconType="outline" link="https://twitter.com/AIcrowdHQ" />
          <SocialButtons socialType="linkedin" iconType="outline" link="https://www.linkedin.com/company/aicrowd" />
          <SocialButtons
            socialType="youtube"
            iconType="outline"
            link="https://www.youtube.com/channel/UCUWbe23kxbwpaAP9AlzZQbQ"
          />
          <SocialButtons socialType="discord" iconType="outline" link="https://discord.gg/8jb55SpVJg" />
        </div>
      </div>
    </div>
  </>
);

export default LandingMenu;
