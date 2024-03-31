//
//  Layout.swift
//
//
//  Created by Kostya Tsyvilko on 24.03.24.
//

import Foundation

public enum Layout {
    public enum Spacing {
        public static var zero: CGFloat = 0

        /// Spacing 5 points
        public static var xSmall: CGFloat = 5

        /// Spacing 10 points
        public static var small: CGFloat = 10

        /// Spacing 15 points
        public static var smallMedium: CGFloat = 15

        /// Spacing 20 points
        public static var medium: CGFloat = 20

        /// Spacing 25 points
        public static var mediumBig: CGFloat = 25

        /// Spacing 30 points
        public static var big: CGFloat = 30
    }

    public enum Radius {
        /// Radius 10 points
        public static var small: CGFloat = 10

        /// Radius 15 points
        public static var smallMedium: CGFloat = 15

        /// Radius 20 points
        public static var medium: CGFloat = 20

        /// Radius 25 points
        public static var mediumBig: CGFloat = 25

        /// Radius 30 points
        public static var big: CGFloat = 30
    }
}
