import SwiftUI

@available(iOS, deprecated: 15)
@available(macOS, deprecated: 12)
@available(tvOS, deprecated: 15)
@available(watchOS, deprecated: 8)
extension Backport where Content: View {

    /// Marks this view as refreshable.
    ///
    /// Apply this modifier to a view to set the ``EnvironmentValues/refresh``
    /// value in the view's environment to a ``RefreshAction`` instance that
    /// uses the specified `action` as its handler. Views that detect the
    /// presence of the instance can change their appearance to provide a
    /// way for the user to execute the handler.
    ///
    /// You can add refresh capability to your own views as well. For
    /// information on how to do that, see ``RefreshAction``.
    ///
    /// - Parameters:
    ///   - action: An asynchronous handler that SwiftUI executes when the
    ///   user requests a refresh. Use this handler to initiate
    ///   an update of model data displayed in the modified view. Use
    ///   `await` in front of any asynchronous calls inside the handler.
    /// - Returns: A view with a new refresh action in its environment.
    public func refreshable(action: @escaping @Sendable () async -> Void) -> some View {
        content.environment(\.backportRefresh, Backport<Any>.RefreshAction(action))
    }

}

@available(iOS, deprecated: 15)
@available(macOS, deprecated: 12)
@available(tvOS, deprecated: 15)
@available(watchOS, deprecated: 8)
extension Backport where Content == Any {

    /// An action that initiates a refresh operation.
    ///
    /// Unlike the official implementation, this backport does not affect any
    /// view's like `List` to provide automatic pull-to-refresh behaviour.
    ///
    /// You can use this to offer refresh capability in your custom views.
    /// Read the ``EnvironmentValues/refresh`` environment value to get the
    /// `RefreshAction` instance for a given ``Environment``. If you find
    /// a non-`nil` value, change your view's appearance or behavior to offer
    /// the refresh to the user, and call the instance to conduct the
    /// refresh. You can call the refresh instance directly because it defines
    /// a ``RefreshAction/callAsFunction()`` method that Swift calls
    /// when you call the instance:
    ///
    ///     struct RefreshableView: View {
    ///         @Environment(\.refresh) private var refresh
    ///
    ///         var body: some View {
    ///             Button("Refresh") {
    ///                 Task {
    ///                     await refresh?()
    ///                 }
    ///             }
    ///             .disabled(refresh == nil)
    ///         }
    ///     }
    ///
    /// Be sure to call the handler asynchronously by preceding it
    /// with `await`. Because the call is asynchronous, you can use
    /// its lifetime to indicate progress to the user. For example,
    /// you might reveal an indeterminate ``ProgressView`` before
    /// calling the handler, and hide it when the handler completes.
    ///
    /// If your code isn't already in an asynchronous context, create a
    /// <doc://com.apple.documentation/documentation/Swift/Task> for the
    /// method to run in. If you do this, consider adding a way for the
    /// user to cancel the task. For more information, see
    /// [Concurrency](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html)
    /// in *The Swift Programming Language*.
    public struct RefreshAction {
        private var action: () async -> Void

        internal init(_ action: @escaping () async -> Void) {
            self.action = action
        }

        public func callAsFunction() async {
            await action()
        }
    }

}

private struct RefreshEnvironmentKey: EnvironmentKey {
    static let defaultValue: Backport<Any>.RefreshAction? = nil
}

@available(iOS, deprecated: 15)
@available(macOS, deprecated: 12)
@available(tvOS, deprecated: 15)
@available(watchOS, deprecated: 8)
public extension EnvironmentValues {

    /// An action that initiates a refresh operation.
    ///
    /// Unlike the official implementation, this backport does not affect any
    /// view's like `List` to provide automatic pull-to-refresh behaviour.
    ///
    /// You can use this to offer refresh capability in your custom views.
    /// Read the ``EnvironmentValues/refresh`` environment value to get the
    /// `RefreshAction` instance for a given ``Environment``. If you find
    /// a non-`nil` value, change your view's appearance or behavior to offer
    /// the refresh to the user, and call the instance to conduct the
    /// refresh. You can call the refresh instance directly because it defines
    /// a ``RefreshAction/callAsFunction()`` method that Swift calls
    /// when you call the instance:
    ///
    ///     struct RefreshableView: View {
    ///         @Environment(\.refresh) private var refresh
    ///
    ///         var body: some View {
    ///             Button("Refresh") {
    ///                 Task {
    ///                     await refresh?()
    ///                 }
    ///             }
    ///             .disabled(refresh == nil)
    ///         }
    ///     }
    ///
    /// Be sure to call the handler asynchronously by preceding it
    /// with `await`. Because the call is asynchronous, you can use
    /// its lifetime to indicate progress to the user. For example,
    /// you might reveal an indeterminate ``ProgressView`` before
    /// calling the handler, and hide it when the handler completes.
    ///
    /// If your code isn't already in an asynchronous context, create a
    /// <doc://com.apple.documentation/documentation/Swift/Task> for the
    /// method to run in. If you do this, consider adding a way for the
    /// user to cancel the task. For more information, see
    /// [Concurrency](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html)
    /// in *The Swift Programming Language*.
    var backportRefresh: Backport<Any>.RefreshAction? {
        get { self[RefreshEnvironmentKey.self] }
        set { self[RefreshEnvironmentKey.self] = newValue }
    }

}
