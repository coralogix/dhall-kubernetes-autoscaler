let imports = ../imports.dhall

let Kubernetes = imports.Kubernetes

let Prelude = imports.Prelude

let ContainerResourcePolicy =
      { Type =
          { containerName : Text
          , mode : Text
          , minAllowed : Prelude.Map.Type Text Text
          , maxAllowed : Prelude.Map.Type Text Text
          }
      , default = {=}
      }

let PodUpdatePolicy =
      { Type = { updateMode : Text }, default.updateMode = "Off" }

let PodResourcePolicy =
      { Type = { containerPolicies : List ContainerResourcePolicy.Type }
      , default = {=}
      }

let RecommendedContainerResources =
      { Type =
          { containerName : Text
          , target : Prelude.Map.Type Text Text
          , lowerBound : Prelude.Map.Type Text Text
          , upperBound : Prelude.Map.Type Text Text
          , uncappedTarget : Prelude.Map.Type Text Text
          }
      , default = {=}
      }

let RecommendedPodResources =
      { Type =
          { containerRecommendation : List RecommendedContainerResources.Type }
      , default = {=}
      }

let VerticalPodAutoscalerCondition =
      { Type =
          { type : Text
          , status : Text
          , lastTransitionTime : Text
          , reason : Text
          , message : Text
          }
      , default = {=}
      }

let VerticalPodAutoscalerSpec =
      { Type =
          { targetRef : Kubernetes.CrossVersionObjectReference.Type
          , updatePolicy : PodUpdatePolicy.Type
          , resourcePolicy : Optional PodResourcePolicy.Type
          }
      , default.resourcePolicy = None PodResourcePolicy.Type
      }

let VerticalPodAutoscalerStatus =
      { Type =
          { recommendation : RecommendedPodResources.Type
          , conditions : List VerticalPodAutoscalerCondition.Type
          }
      , default = {=}
      }

let VerticalPodAutoscaler =
      { Type =
          { apiVersion : Text
          , kind : Text
          , metadata : Kubernetes.ObjectMeta.Type
          , spec : VerticalPodAutoscalerSpec.Type
          , status : Optional VerticalPodAutoscalerStatus.Type
          }
      , default =
          { apiVersion = "autoscaling.k8s.io/v1beta2"
          , kind = "VerticalPodAutoscaler"
          , status = None VerticalPodAutoscalerStatus.Type
          }
      }

let VerticalPodAutoscalerList =
      { Type =
          { apiVersion : Text
          , kind : Text
          , metadata : Kubernetes.ObjectMeta.Type
          , items : List VerticalPodAutoscaler.Type
          }
      , default = {=}
      }

in  { ContainerResourcePolicy = ContainerResourcePolicy
    , PodResourcePolicy = PodResourcePolicy
    , PodUpdatePolicy = PodUpdatePolicy
    , RecommendedContainerResources = RecommendedContainerResources
    , RecommendedPodResources = RecommendedPodResources
    , VerticalPodAutoscaler = VerticalPodAutoscaler
    , VerticalPodAutoscalerCondition = VerticalPodAutoscalerCondition
    , VerticalPodAutoscalerList = VerticalPodAutoscalerList
    , VerticalPodAutoscalerSpec = VerticalPodAutoscalerSpec
    , VerticalPodAutoscalerStatus = VerticalPodAutoscalerStatus
    }
