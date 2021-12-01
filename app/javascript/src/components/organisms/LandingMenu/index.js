import React from 'react';
import Link from 'next/link';

import styles from './landingMenu.module.scss';
import SocialButtons from 'src/components/atoms/Button/SocialButtons';
const { main, menuWrapper, loginText, socialIconWrapper } = styles;

const LandingMenu = ({ profileMenuItem, isLoggedIn }) => (
  <>
    <div className={main}>
      <div className={menuWrapper}>
        <Link href="/landing_page/host">
          <a>Host a Challenge</a>
        </Link>
        <Link href="/challenges">
          <a>Challenges</a>
        </Link>
        <Link href="/showcase">
          <a>Showcase</a>
        </Link>
        <Link href="/research">
          <a>Research</a>
        </Link>
        <Link href="https://discourse.aicrowd.com/">
          <a>Forum</a>
        </Link>
        <Link href="https://blog.aicrowd.com/">
          <a>Blog</a>
        </Link>
        {!isLoggedIn && (
          <>
            <div className={loginText}>
              <Link href="/participants/sign_in">
                <a>Log In</a>
              </Link>
            </div>
            <Link href="/participants/sign_up">
              <a>Signup</a>
            </Link>
          </>
        )}

        {isLoggedIn &&
          profileMenuItem.map(item => {
            const { name, link } = item;
            return (
              <div className={name === 'Profile' ? loginText : ''} key={name}>
                <Link href={link}>
                  <a>{name}</a>
                </Link>
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
          <SocialButtons socialType="discord" iconType="outline" link="https://discord.com/invite/XEa56FP" />
        </div>
      </div>
    </div>
  </>
);

export default LandingMenu;
