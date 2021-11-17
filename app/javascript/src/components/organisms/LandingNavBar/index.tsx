import React, { useState, useCallback, useEffect } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/router';

import AicrowdLogo from 'src/components/atoms/AicrowdLogo';
import ButtonDefault from 'src/components/atoms/Button/ButtonDefault';
import LandingDropdownMenu from 'src/components/molecules/LandingDropdownMenu';
import useMediaQuery from 'src/hooks/useMediaQuery';
import { sizes } from 'src/constants/screenSizes';
import useBoolean from '../../../hooks/useBoolean';
import useHoverDropdown from 'src/hooks/useHoverDropdown';
import styles from './landingNavBar.module.scss';
const {
  main,
  navMenuIcon,
  fullLogo,
  cross,
  iconWrapper,
  navLinkWrapper,
  moreText,
  loginText,
  dropdownNavItemWrapper,
  navItem,
} = styles;

export type LandingNavBarProps = {
  handleMenu: () => void;
  isMenuOpen: boolean;
  setMenu: (value: boolean) => void;
  moreMenuItem: Array<{ name: string; link: string }>;
  challengesMenuItem: Array<{ name: string; link: string }>;
  communityMenuItem: Array<{ name: string; link: string }>;
};

const LandingNavBar = ({
  handleMenu,
  isMenuOpen,
  setMenu,
  moreMenuItem,
  challengesMenuItem,
  communityMenuItem,
}: LandingNavBarProps) => {
  const isM = useMediaQuery(sizes.medium);
  const router = useRouter();

  const { show, enterButton, leaveButton, enterMenu, leaveMenu } = useHoverDropdown();
  const { value: isDropdown, setValue: setDropdown } = useBoolean();
  const [navItemHovered, setNavItemHovered] = useState({
    hoveredOn: '',
    menuItems: [],
  });
  const { hoveredOn, menuItems } = navItemHovered;

  // handle dropdown data based on which nav item hovered on
  const handleMouseEnter = useCallback(
    menuName => {
      switch (menuName) {
        case 'challenges':
          setNavItemHovered({
            hoveredOn: menuName,
            menuItems: challengesMenuItem,
          });
          break;
        case 'community':
          setNavItemHovered({
            hoveredOn: menuName,
            menuItems: communityMenuItem,
          });
          break;
        case 'more':
          setNavItemHovered({
            hoveredOn: menuName,
            menuItems: moreMenuItem,
          });
          break;

        default:
          break;
      }
      enterButton();
    },
    [setNavItemHovered]
  );

  useEffect(() => {
    setDropdown(show);
  }, [show]);

  return (
    <>
      <div className={main}>
        <Link href="/">
          {/* Aicrowd logo*/}
          <div className={fullLogo}>
            <AicrowdLogo type="full" />
          </div>
        </Link>

        {/* Hamburger icon Show only on small screens */}
        {isM && (
          <div className={iconWrapper} onClick={handleMenu} onMouseEnter={() => setMenu(true)}>
            <div className={isMenuOpen ? cross : navMenuIcon}>
              <span></span>
              <span></span>
            </div>
          </div>
        )}

        {/* Show only on large screens */}
        {!isM && (
          <div className={navLinkWrapper}>
            {isDropdown && (
              <LandingDropdownMenu
                menu={menuItems}
                top="50px"
                left={hoveredOn === 'community' && '129px'}
                setIsOpen={setDropdown}
                showSocial={hoveredOn === 'more'}
                enterMenu={enterMenu}
                leaveMenu={leaveMenu}
                disableOnClickOutside={true}
              />
            )}

            <div className={dropdownNavItemWrapper} onMouseLeave={leaveButton}>
              <div className={navItem} onMouseEnter={() => handleMouseEnter('challenges')}>
                Challenges
              </div>
              <div className={navItem} onMouseEnter={() => handleMouseEnter('community')}>
                Community
              </div>
              <div className={moreText} onMouseEnter={() => handleMouseEnter('more')}>
                More
              </div>
            </div>
            <Link href="/login">
              <a className={loginText}>Log in</a>
            </Link>
            <ButtonDefault
              text="Sign Up"
              type="secondary"
              size="large"
              iconClass="arrow-right"
              iconColor="#F0524D"
              fontWeight="500"
              hoverBorder="1px solid #f04d7e"
              handleClick={() => router.push('/signup')}
            />
          </div>
        )}
      </div>
    </>
  );
};

export default LandingNavBar;
