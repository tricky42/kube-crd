# Problems introducing godep for dependency management 
## Steps to reproduce
* Get dependencies by running dep ensure
```
dep ensure
```
* Compile go files
```
$ go build
# github.com/tricky42/kube-crd/vendor/k8s.io/client-go/tools/clientcmd/api
vendor/k8s.io/client-go/tools/clientcmd/api/register.go:35: cannot use Config literal (type *Config) as type runtime.Object in argument to scheme.AddKnownTypes:
	*Config does not implement runtime.Object (missing DeepCopyObject method)
# github.com/tricky42/kube-crd/vendor/k8s.io/client-go/pkg/api
vendor/k8s.io/client-go/pkg/api/defaults.go:26: scheme.AddDefaultingFuncs undefined (type *runtime.Scheme has no field or method AddDefaultingFuncs)
vendor/k8s.io/client-go/pkg/api/ref.go:44: impossible type assertion:
	*ObjectReference does not implement runtime.Object (missing DeepCopyObject method)
vendor/k8s.io/client-go/pkg/api/register.go:80: cannot use Pod literal (type *Pod) as type runtime.Object in argument to scheme.AddKnownTypes:
	*Pod does not implement runtime.Object (missing DeepCopyObject method)
vendor/k8s.io/client-go/pkg/api/register.go:81: cannot use PodList literal (type *PodList) as type runtime.Object in argument to scheme.AddKnownTypes:
	*PodList does not implement runtime.Object (missing DeepCopyObject method)
vendor/k8s.io/client-go/pkg/api/register.go:82: cannot use PodStatusResult literal (type *PodStatusResult) as type runtime.Object in argument to scheme.AddKnownTypes:
	*PodStatusResult does not implement runtime.Object (missing DeepCopyObject method)
vendor/k8s.io/client-go/pkg/api/register.go:83: cannot use PodTemplate literal (type *PodTemplate) as type runtime.Object in argument to scheme.AddKnownTypes:
	*PodTemplate does not implement runtime.Object (missing DeepCopyObject method)
vendor/k8s.io/client-go/pkg/api/types.go:3821: undefined: v1.LabelHostname
vendor/k8s.io/client-go/pkg/api/types.go:3821: undefined: v1.LabelZoneFailureDomain
vendor/k8s.io/client-go/pkg/api/types.go:3821: undefined: v1.LabelZoneRegion
vendor/k8s.io/client-go/pkg/api/types.go:3821: const initializer v1.LabelHostname + "," + v1.LabelZoneFailureDomain + "," + v1.LabelZoneRegion is not a constant
vendor/k8s.io/client-go/pkg/api/register.go:83: too many errors
```

Somehow the downloaded dependencies can not be compiled :( 
````
$ go version
go version go1.8.3 darwin/amd64      
```


# Kubernetes Custom Resources (CRD) Tutorial

Tutorial for building Kubernetes Custom Resources (CRD) extensions
you can see the full tutorial documentation in: [The New Stack](https://thenewstack.io/extend-kubernetes-1-7-custom-resources)

**Note:** CustomResourceDefinition (CRD) is the successor of the deprecated ThirdPartyResource.

this example is based on Kubernetes [apiextensions-apiserver](https://github.com/kubernetes/apiextensions-apiserver) example  

## Organization 

the example contain 3 files:

* crd      - define and register our CRD class 
* client   - client library to create and use our CRD (CRUD)
* kube-crd - main part, demonstrate how to create, use, and watch our CRD

## Running

```
# assumes you have a working kubeconfig, not required if operating in-cluster
go run *.go -kubeconf=$HOME/.kube/config
```


## kube-crd

kube-crd demonstrates the CRD usage, it shoes how to:

1. Connect to the Kubernetes cluster 
2. Create the new CRD if it doesn't exist  
3. Create a new custom client 
4. Create a new Example object using the client library we created 
5. Create a controller that listens to events associated with new resources

The example CRD is in the following structure:


```go
type Example struct {
      meta_v1.TypeMeta   `json:",inline"`
      meta_v1.ObjectMeta `json:"metadata"`
      Spec               ExampleSpec   `json:"spec"`
      Status             ExampleStatus `json:"status,omitempty"`
}
type ExampleSpec struct {
      Foo string `json:"foo"`
      Bar bool   `json:"bar"`
      Baz int    `json:"baz,omitempty"`
}

type ExampleStatus struct {
      State   string `json:"state,omitempty"`
      Message string `json:"message,omitempty"`
}
```

* The Metadata part contain standard Kubernetes properties like name, namespace, labels, and annotations 
* The Spec contain the desired resource configuration 
* The Status part is usually filled by the controller in response to Spec updates 

