/// Configuration for Cloudinary image uploads.
///
/// The app stores only the resulting image URL in Firestore, so any host that
/// returns a public URL works — we use Cloudinary's free tier instead of
/// Firebase Storage (which now requires the paid Blaze plan to provision a
/// bucket).
///
/// SETUP (one time):
///   1. Create a free account at https://cloudinary.com
///   2. Dashboard → note your **Cloud name**.
///   3. Settings → Upload → Upload presets → "Add upload preset":
///        - Signing Mode: **Unsigned**
///        - (recommended) restrict it: allowed formats = images only,
///          max file size = 5 MB, and set an "Asset folder" if you like.
///      Save, and copy the preset **name**.
///   4. Paste both values below (or pass them at build time with
///      --dart-define=CLOUDINARY_CLOUD_NAME=... --dart-define=CLOUDINARY_UPLOAD_PRESET=...).
///
/// Both values are safe to ship in the client — an unsigned preset is designed
/// to be used from client apps. It does mean anyone who extracts them could
/// upload to your account, so keep the preset's format/size restrictions on and
/// consider enabling Cloudinary's auto-moderation if abuse becomes a problem.
class CloudinaryConfig {
  const CloudinaryConfig._();

  static const placeholderCloudName = 'YOUR_CLOUD_NAME';
  static const placeholderUploadPreset = 'YOUR_UNSIGNED_PRESET';

  static const cloudName = String.fromEnvironment(
    'CLOUDINARY_CLOUD_NAME',
    defaultValue: 'dckaippk',
  );

  static const uploadPreset = String.fromEnvironment(
    'CLOUDINARY_UPLOAD_PRESET',
    defaultValue: 'campusswap',
  );

  /// Largest image we allow, matching the old Storage rules' 5 MB cap.
  static const maxBytes = 5 * 1024 * 1024;

  static bool get isConfigured =>
      cloudName != placeholderCloudName &&
      uploadPreset != placeholderUploadPreset;
}
